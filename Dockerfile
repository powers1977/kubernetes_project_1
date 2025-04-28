FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html

# Expose port 80 for HTTP traffic
EXPOSE 80

# Keep Nginx running in the foreground
#CMD ["nginx", "-g", "daemon off;"]

