FROM xidam/nginx_php:1.1
ENV php_version 5.5.6
ENV php_fpm_conf /opt/.phps/${php_version}/etc/php-fpm.conf 
ENV nginx_default_conf /etc/nginx/sites-enabled/default.conf
ENV supervisord_conf /etc/supervisord.conf
ENV PHPRC=/opt/.phps/${php_version}/etc/php.ini
ENV PATH="/opt/.phps/${php_version}/bin:$PATH"
ENV PATH="/opt/.phps/${php_version}/sbin:$PATH"
ENV php_version_sh /opt/php-version.sh

RUN apt install -y nginx supervisor git 
RUN curl -# -L https://github.com/wilmoore/php-version/tarball/master | tar -xz --strip 1 -C /opt/
ADD conf/supervisord.conf /etc/supervisord.conf
ADD scripts/php-version.sh /opt/php-version.sh

# Copy our nginx config
RUN rm -Rf /etc/nginx/nginx.conf \
rm /etc/nginx/sites-available/default* \
mkdir /var/www/html/

# nginx site config
ADD conf/nginx.conf /etc/nginx/nginx.conf
ADD conf/nginx_default.conf /etc/nginx/sites-available/default.conf
RUN ln -s /etc/nginx/sites-available/default.conf ${nginx_default_conf} 
ADD conf/php-fpm.conf /opt/.phps/${php_version}/etc/php-fpm.conf
ADD conf/php.ini /opt/.phps/${php_version}/etc/php.ini
ADD www/index.php /var/www/html/index.php
ADD conf/supervisord.conf ${supervisord_conf}
# update php-fpm and nginx to reflect the current php version
RUN sed -i -e "s/php5-fpm-app/php${php_version}-fpm-app/g" ${php_fpm_conf} && \
sed -i -e "s/nobody/www-data/g" ${php_fpm_conf} && \
sed -i -e "s/php5-fpm-app/php${php_version}-fpm-app/g" ${nginx_default_conf} && \
sed -i -e "s/PHPVER/${php_version}/g" ${supervisord_conf} && \
sed -i -e "s/\$HOME/\$DIR/g" $php_version_sh 
#
RUN line=`grep -n PROGRAM_DISPLAY_VERSION $php_version_sh | head -n 1 | cut -d: -f1`; echo $line; sed -i "${line}i\  local DIR=/opt/\\" $php_version_sh 

CMD ["/usr/bin/supervisord", "-n", "-c",  "/etc/supervisord.conf"]
