export default {
    port: 8080,
    fetch(request) {
        return new Response("Hello from Bun!");
    },
};
