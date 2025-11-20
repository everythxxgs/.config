<script>
  let count = 0;
</script>

<div class="container">
  <h1>Hello World</h1>
  <button on:click={() => count++}>
    Click me: {count}
  </button>
</div>

<style>
  .container {
    padding: 1rem;
  }
</style>
