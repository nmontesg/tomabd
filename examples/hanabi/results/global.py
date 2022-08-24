import pandas as pd

df = pd.read_csv("2_players.csv", sep=';')
print(df.head())
print(df.info())

df.plot("avg_explicit_info", "score", kind="scatter")
df.plot("avg_implicit_info", "score", kind="scatter")

df.plot("avg_explicit_info", "efficiency", kind="scatter")
df.plot("avg_implicit_info", "efficiency", kind="scatter")

total_explicit_info = df.apply(lambda x: x.hints*x.avg_explicit_info, axis=1)
df.insert(df.shape[1], "total_explicit_info", total_explicit_info)

total_implicit_info = df.apply(lambda x: x.hints*avg_implicit_info, axis=1)
df.insert(df.shape[1], "total_implicit_info", total_implicit_info)

df.plot("total_explicit_info", "score", kind="scatter")
df.plot("total_implicit_info", "score", kind="scatter")

df.plot("total_explicit_info", "efficiency", kind="scatter")
df.plot("total_implicit_info", "efficiency", kind="scatter")
