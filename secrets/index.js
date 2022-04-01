module.exports = async function(ctx, req) {
  const res = {
    success: true,
    data: {
      user: process.env.USER,
      pass: process.env.PASS,
    },
  };

  ctx.res = {
    status: 200,
    body: JSON.stringify(res),
  };
};
