#!/bin/bash
set -e

cd /var/www

echo "Bootstrapping Laravel..."

# -----------------------------------
# 1. Install Laravel if missing
# -----------------------------------
if [ ! -f artisan ]; then
    echo "Laravel not found. Installing..."

    rm -rf temp

    composer create-project laravel/laravel temp

    echo "Moving Laravel files..."

    mv temp/* .
    mv temp/.[!.]* . 2>/dev/null || true

    rm -rf temp
fi

# -----------------------------------
# 2. Apply Docker .env only if .env is missing or empty
# -----------------------------------
cp .env.docker .env

# -----------------------------------
# 3. Install dependencies
# -----------------------------------
if [ ! -d vendor ]; then
    echo "Installing dependencies..."
    composer install --no-interaction --prefer-dist --optimize-autoloader
fi

#--------------------------------
# 1. Fix permissions
#--------------------------------
echo "Fixing Permissions..."
chown -R www-data:www-data storage bootstrap/cache || true
chown -R 775 storage bootstrap/cache || true
chmod 1777 /tmp || true

# -----------------------------------
# 5. Generate app key
# -----------------------------------
if ! grep -q "^APP_KEY=base64" .env; then
    echo "Generating app key..."
    php artisan key:generate --force
fi

#--------------------------------
# 2. Run migrations (background)
#--------------------------------
(
    echo "Running migrations..."
    php artisan migrate --force || true

    echo "Clearing config cache.."
    php artisan config:cache || true
)
#--------------------------------
# 3. Start PHP-FPM
#--------------------------------
echo "Strating PHP-FPM..."
exec "$@"
