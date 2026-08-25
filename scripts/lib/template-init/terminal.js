import readline from 'readline';
import { stdin, stdout } from 'process';

/** @type {Record<string, string>} */
export const c = {
  reset: '\x1b[0m',
  bold: '\x1b[1m',
  dim: '\x1b[2m',
  cyan: '\x1b[36m',
  brightCyan: '\x1b[96m',
  magenta: '\x1b[35m',
  brightMagenta: '\x1b[95m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  white: '\x1b[37m',
  red: '\x1b[31m',
  bgCyan: '\x1b[46m',
  black: '\x1b[30m',
};

/**
 * @param {boolean} [enabled]
 */
export function supportsStyle(enabled = stdout.isTTY) {
  return Boolean(enabled) && !process.env.NO_COLOR;
}

/**
 * @param {string} text
 * @param {string} code
 */
function paint(text, code) {
  if (!supportsStyle()) return text;
  return `${code}${text}${c.reset}`;
}

/** @returns {string} */
export function brand() {
  if (!supportsStyle()) return '@open-templates';
  return `${paint('@', `${c.brightCyan}${c.bold}`)}${paint('open-templates', `${c.bold}${c.white}`)}`;
}

/**
 * @param {string} [subtitle]
 */
export function brandHeader(subtitle = 'template init') {
  const width = 52;
  const line = '─'.repeat(width);
  console.log('');
  console.log(paint(line, c.dim));
  console.log(`  ${brand()} ${paint(`· ${subtitle}`, c.dim)}`);
  console.log(paint(line, c.dim));
  console.log('');
}

/**
 * @param {number} n
 * @param {string} title
 */
export function step(n, title) {
  const badge = paint(` Step ${n} `, `${c.bgCyan}${c.black}${c.bold}`);
  console.log(`${badge} ${paint(title, `${c.bold}${c.white}`)}\n`);
}

/**
 * @param {string} title
 * @param {{ label: string, value: string }[]} rows
 */
export function infoPanel(title, rows) {
  console.log(paint(title, `${c.bold}${c.brightMagenta}`));
  for (const row of rows) {
    console.log(
      `  ${paint(row.label.padEnd(10), c.dim)} ${paint(row.value, c.white)}`
    );
  }
  if (rows.length > 0) console.log('');
}

/**
 * @param {string} title
 * @param {{ label: string, value: string }[]} rows
 */
export function summaryPanel(title, rows) {
  console.log(paint(`\n${title}`, `${c.bold}${c.yellow}`));
  for (const row of rows) {
    console.log(
      `  ${paint(row.label.padEnd(10), c.dim)} ${paint(row.value, c.cyan)}`
    );
  }
  console.log('');
}

/**
 * @typedef {{ value: string, label: string, hint?: string }} SelectChoice
 */

/**
 * @param {object} options
 * @param {string} options.message
 * @param {SelectChoice[]} options.choices
 * @param {number} [options.defaultIndex]
 * @returns {Promise<SelectChoice>}
 */
export function select({ message, choices, defaultIndex = 0 }) {
  if (!choices.length) {
    throw new Error('select() requires at least one choice');
  }

  if (!supportsStyle() || !stdin.isTTY) {
    return Promise.resolve(choices[defaultIndex] ?? choices[0]);
  }

  let index = Math.min(Math.max(defaultIndex, 0), choices.length - 1);
  let lineCount = 0;
  let pending = '';

  const hint = paint('↑↓ navigate · enter confirm', c.dim);

  const render = () => {
    const lines = [
      '',
      `${paint('?', c.cyan)} ${paint(message, `${c.bold}${c.white}`)}`,
      ...choices.map((choice, i) => formatChoice(choice, i === index)),
      `  ${hint}`,
    ];

    if (lineCount > 0) {
      readline.moveCursor(stdout, 0, -lineCount);
      readline.clearScreenDown(stdout);
    }

    stdout.write(`${lines.join('\n')}\n`);
    lineCount = lines.length;
  };

  return new Promise((resolve) => {
    stdin.setRawMode(true);
    stdin.resume();
    stdin.setEncoding('utf8');

    const cleanup = () => {
      stdin.removeListener('data', onKey);
      stdin.setRawMode(false);
      stdin.pause();
      stdout.write(paint('\n', c.reset));
    };

    const onKey = (chunk) => {
      const key = pending ? `${pending}${chunk}` : chunk;
      pending = '';

      if (key === '\u001b' || key === '\u001b[') {
        pending = key;
        return;
      }

      if (key === '\u0003' || key === '\u0004') {
        cleanup();
        console.log(paint('\nCancelled.', c.dim));
        process.exit(0);
      }

      if (key === '\r' || key === '\n') {
        cleanup();
        resolve(choices[index]);
        return;
      }

      if (
        key === '\u001b[A' ||
        key === '\u001bOA' ||
        key.toLowerCase() === 'k'
      ) {
        index = Math.max(0, index - 1);
        render();
        return;
      }

      if (
        key === '\u001b[B' ||
        key === '\u001bOB' ||
        key.toLowerCase() === 'j'
      ) {
        index = Math.min(choices.length - 1, index + 1);
        render();
      }
    };

    stdin.on('data', onKey);
    render();
  });
}

/**
 * @param {SelectChoice} choice
 * @param {boolean} active
 */
function formatChoice(choice, active) {
  const pointer = active
    ? paint('❯', `${c.brightCyan}${c.bold}`)
    : paint(' ', c.dim);
  const label = active
    ? paint(choice.label, `${c.bold}${c.white}`)
    : paint(choice.label, c.dim);
  const hint = choice.hint
    ? ` ${paint(`(${choice.hint})`, c.dim)}`
    : '';
  return `  ${pointer} ${label}${hint}`;
}

/**
 * @param {string} message
 * @param {boolean} [defaultYes]
 */
export async function confirm(message, defaultYes = true) {
  const choice = await select({
    message,
    choices: [
      {
        value: 'yes',
        label: 'Yes, proceed',
        hint: defaultYes ? 'default' : undefined,
      },
      { value: 'no', label: 'No, cancel' },
    ],
    defaultIndex: defaultYes ? 0 : 1,
  });

  if (choice.value === 'no') {
    console.log(paint('Cancelled.', c.dim));
    process.exit(0);
  }
}

/**
 * @param {string} label
 * @param {string} [defaultValue]
 */
export function promptTextOptional(label, defaultValue = '') {
  const suffix = defaultValue
    ? ` ${paint(`[${defaultValue}]`, c.dim)}`
    : '';

  return new Promise((resolve) => {
    const rl = readline.createInterface({ input: stdin, output: stdout });
    rl.question(
      `${paint('?', c.cyan)} ${paint(label, `${c.bold}${c.white}`)}${suffix}: `,
      (answer) => {
        rl.close();
        resolve(answer.trim() || defaultValue);
      }
    );
  });
}

/**
 * @param {string} label
 * @param {string} [defaultValue]
 */
export function promptText(label, defaultValue = '') {
  const suffix = defaultValue
    ? ` ${paint(`[${defaultValue}]`, c.dim)}`
    : '';

  return new Promise((resolve) => {
    const rl = readline.createInterface({ input: stdin, output: stdout });
    rl.question(
      `${paint('?', c.cyan)} ${paint(label, `${c.bold}${c.white}`)}${suffix}: `,
      (answer) => {
        rl.close();
        const value = answer.trim() || defaultValue;
        if (!value) {
          error(`${label} is required.`);
          process.exit(1);
        }
        resolve(value);
      }
    );
  });
}

/** @param {string} message */
export function success(message) {
  console.log(`${paint('✓', c.green)} ${message}`);
}

/** @param {string} message */
export function error(message) {
  console.error(`${paint('✗', c.red)} ${paint(message, c.red)}`);
}

/** @param {string} message */
export function warn(message) {
  console.warn(`${paint('!', c.yellow)} ${message}`);
}

/** @param {string} message */
export function muted(message) {
  console.log(paint(message, c.dim));
}

/**
 * @param {string} from
 * @param {string} to
 */
export function copyLine(from, to) {
  console.log(
    `${paint('✓', c.green)} ${paint(to, c.white)} ${paint('←', c.dim)} ${paint(from, c.cyan)}`
  );
}

/**
 * @param {string} title
 */
export function section(title) {
  console.log(paint(`\n${title}`, `${c.bold}${c.brightMagenta}`));
}
