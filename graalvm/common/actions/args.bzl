'''Defines some helper functions for working with Bazel `Args` objects.
'''

def singleton_args(ctx, arg):
    args = ctx.actions.args()
    args.add(arg)
    return args
