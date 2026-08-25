/**
 * @typedef {object} GitContext
 * @property {string | null} owner
 * @property {string | null} repo
 * @property {string | null} ownerId
 * @property {string | null} displayName
 * @property {string | null} remoteUrl
 * @property {string | null} userName
 * @property {string | null} userEmail
 * @property {string | null} ghLogin
 * @property {string | null} ghId
 * @property {string | null} ghName
 * @property {string[]} sources
 */

/**
 * @typedef {object} DetectedAuthor
 * @property {string | null} login
 * @property {string | null} displayName
 * @property {string | null} ownerId
 * @property {string | null} email
 * @property {string | null} profileUrl
 * @property {string[]} sources
 * @property {boolean} detected
 */

/**
 * @typedef {object} AuthorConfig
 * @property {string} authorLogin
 * @property {string} authorDisplayName
 * @property {string | null} authorOwnerId
 * @property {string} authorEmail
 */

/**
 * @typedef {object} InitArgs
 * @property {string | null} [owner]
 * @property {string | null} [repo]
 * @property {string | null} [packageName]
 * @property {string | null} [displayName]
 * @property {string | null} [authorLogin]
 * @property {string | null} [authorEmail]
 * @property {string | null} [ownerId]
 * @property {string | null} [bundler]
 * @property {boolean} [yes]
 * @property {boolean} [help]
 * @property {boolean} [noCleanup]
 */

/**
 * @typedef {object} InitConfig
 * @property {string} owner
 * @property {string} repo
 * @property {string} [packageName]
 * @property {string} displayName
 * @property {string} [bundler]
 * @property {string} [email]
 * @property {string} [ownerId]
 * @property {string} [authorLogin]
 * @property {string} [authorDisplayName]
 * @property {string} [authorEmail]
 * @property {string | null} [authorOwnerId]
 */

/**
 * @typedef {object} AuthorStepConfig
 * @property {string} [stepTitle]
 * @property {string} [panelTitle]
 * @property {string} [selectMessage]
 * @property {string} [acceptLabel]
 */

/**
 * @typedef {object} TemplateInitOptions
 * @property {string} root
 * @property {string} [templatesDir]
 * @property {[string, string][]} manifest
 * @property {InitArgs} args
 * @property {boolean} [includePackageName]
 * @property {boolean} [includeAuthorStep]
 * @property {boolean} [includeBundler]
 * @property {string} [defaultBundler]
 * @property {string} [nextSteps]
 * @property {string} [templateLabel]
 * @property {import('./types.js').AuthorStepConfig} [authorStep]
 * @property {'all' | 'keep' | false} [scriptsCleanup]
 * @property {string[]} [scriptsKeep]
 */

export {};
