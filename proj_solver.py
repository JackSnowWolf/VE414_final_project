import os
import numpy as np
import pandas as pd
from matplotlib import pyplot as plt
from sklearn.cluster import KMeans
from sklearn import preprocessing
from matplotlib import animation
from mpl_toolkits.mplot3d import Axes3D, proj3d


def extract_close(data_frame):
    close_df = data_frame.drop([data_frame.columns[0], "Potter", "Weasley", "Granger", "Trip", "Far"], axis=1)
    close_df = close_df.loc[close_df["Close"] > 0]
    return close_df


def extract_far(data_frame):
    far_df = data_frame.drop([data_frame.columns[0], "Potter", "Weasley", "Granger", "Trip", "Close"], axis=1)
    far_df = far_df.loc[far_df["Far"] > 0]
    return far_df


#
# def animate(i):
#     ax.view_init(elev=35., azim=i)
#     return fig,


if __name__ == '__main__':
    proj_df = pd.read_csv("data_proj_414.csv")
    close_df = extract_close(proj_df)
    far_df = extract_far(proj_df)
    close_df_t = close_df
    close_df = close_df.drop("Close", axis=1)
    # close_standardized = preprocessing.scale(close_df)
    # wcss = []
    # for i in range(1, 20):
    #     kmeans = KMeans(n_clusters=i, init='k-means++', random_state=98)
    #     kmeans.fit(close_standardized)
    #     wcss.append(kmeans.inertia_)
    # plt.plot(range(1, 20), wcss)
    # plt.title('The Elbow Method')
    # plt.xlabel('Number of clusters')
    # plt.ylabel('WCSS')
    # plt.savefig("pic/find_num_clusters.jpg")

    kmeans = KMeans(n_clusters=30, init='k-means++', random_state=98)
    y_kmeans = kmeans.fit_predict(close_df)  # beginning of  the cluster numbering with 1 instead of 0
    print(kmeans.cluster_centers_)
    y_kmeans1 = y_kmeans + 1  # New Dataframe called cluster
    cluster = pd.DataFrame(y_kmeans1)  # Adding cluster to the Dataset1
    close_df['cluster'] = cluster  # Mean of clusters
    close_df_t = close_df_t[close_df["cluster"] == 10]
    close_df = close_df[close_df["cluster"] == 10]
    kmeans_mean_cluster = pd.DataFrame(round(close_df.groupby('cluster').mean(), 1))
    print(kmeans_mean_cluster)

    fig = plt.figure(figsize=(12, 10))
    ax = fig.add_subplot(111)
    # c=y_kmeans1
    plt.scatter(close_df.iloc[:, 0], close_df.iloc[:, 1], marker='o',  cmap="jet")
    plt.title('Kmean Clustering')
    ax.set_xlabel("X")
    ax.set_ylabel("Y")

    plt.savefig("pic/kmean2d.jpg")
    #
    fig = plt.figure(figsize=(12, 10))
    ax = fig.add_subplot(111, projection='3d')
    ax.scatter(close_df_t.iloc[:, 0], close_df_t.iloc[:, 1], close_df_t["Close"], marker='o',
               cmap='jet')  # plot points with cluster dependent colors
    ax.set_xlabel("X")
    ax.set_ylabel("Y")
    ax.set_zlabel("Close")
    plt.title('Kmean Clustering 3D')
    plt.savefig("pic/kmean3d.jpg")
    #
    # anim = animation.FuncAnimation(fig, animate,
    #                                frames=360, interval=20, blit=True)
    # anim.save('pic/kmean_3Dpoints_animation.mp4', fps=30, extra_args=['-vcodec', 'libx264'])
