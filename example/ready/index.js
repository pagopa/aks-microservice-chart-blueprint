module.exports = async function(ctx, req) {
  const res = {
    success: true,
  };

  ctx.res = {
    status: 200,
    body: JSON.stringify(res),
  };
};
