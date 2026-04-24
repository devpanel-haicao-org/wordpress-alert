<?php
/**
 * @file
 * DevPanel WordPress settings overrides.
 *
 * Include this file from wp-config.php after the database settings are defined.
 * DB credentials and salts are already set by wp config create, so we only
 * add dynamic URL and performance settings here.
 */

// WordPress database table prefix (override if not already set).
if (!isset($table_prefix)) {
    $table_prefix = 'wp_';
}

// WordPress debugging configuration.
if (!defined('WP_DEBUG')) {
    define('WP_DEBUG', false);
}
if (!defined('WP_DEBUG_LOG')) {
    define('WP_DEBUG_LOG', true);
}
if (!defined('WP_DEBUG_DISPLAY')) {
    define('WP_DEBUG_DISPLAY', false);
}

// Performance settings.
if (!defined('WP_MEMORY_LIMIT')) {
    define('WP_MEMORY_LIMIT', '256M');
}
if (!defined('WP_MAX_MEMORY_LIMIT')) {
    define('WP_MAX_MEMORY_LIMIT', '512M');
}
if (!defined('DISALLOW_FILE_EDIT')) {
    define('DISALLOW_FILE_EDIT', true);
}

// Set WP_HOME and WP_SITEURL dynamically from the current request.
if (!defined('WP_HOME')) {
    if (isset($_SERVER['HTTP_HOST'])) {
        $scheme = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ? 'https' : 'http';
        $current_host = $_SERVER['HTTP_HOST'];
        define('WP_HOME',    $scheme . '://' . $current_host);
        define('WP_SITEURL', $scheme . '://' . $current_host);
    } elseif (getenv('DP_HOSTNAME')) {
        define('WP_HOME',    'https://' . getenv('DP_HOSTNAME'));
        define('WP_SITEURL', 'https://' . getenv('DP_HOSTNAME'));
    }
} elseif (!defined('WP_SITEURL')) {
    define('WP_SITEURL', WP_HOME);
}

// Absolute path to the WordPress directory.
if (!defined('ABSPATH')) {
    define('ABSPATH', __DIR__ . '/');
}