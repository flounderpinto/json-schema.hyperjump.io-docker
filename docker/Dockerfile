FROM nginx:1.27.3

COPY json-schema.hyperjump.io /usr/share/nginx/html

#The index.html has some code to force https.  Remove these lines.
RUN index="/usr/share/nginx/html/index.html" && \
    remove_text_1="      if (location.hostname" && \
    remove_text_2="        location" && \
    remove_text_3="      }" && \
    sed -i "s|$remove_text_1|//$remove_text_1|" "$index" && \
    sed -i "s|$remove_text_2|//$remove_text_2|" "$index" && \
    sed -i "s|$remove_text_3|//$remove_text_3|" "$index"