# CS 61 - Final Project
# Database Systems
# Carter Kruse

import pandas as pd
import mysql.connector

from sklearn.preprocessing import LabelEncoder

def connect():
    mydb = mysql.connector.connect (
        host = 'localhost',
        user = 'root',
        password = 'password',
        database = 'premier_league'
    )

    mycursor = mydb.cursor()

    query  = 'SELECT * FROM player_season \
                JOIN player_info \
                    USING (player_id) \
                JOIN season \
                    USING (season_id) \
                JOIN team_info \
                    USING (player_season_id) \
                JOIN general_stats \
                    USING (player_season_id) \
                JOIN offensive_stats \
                    USING (player_season_id) \
                JOIN defensive_stats \
                    USING (player_season_id) \
                JOIN foul_stats \
                    USING (player_season_id)'

    mycursor.execute(query)

    myresult = mycursor.fetchall()

    matrix = []
    for row in myresult:
        matrix.append(row)

    column_names = ['id_1', 'id_2', 'id_3', 'player_first_name', 'player_last_name', 'born', 'nation', 'season', 'squad', \
                    'position', 'market_value', 'app', 'minutes', 'sub_on', 'sub_off', 'goals', 'passes', 'assists', 'shots', \
                    'sot', 'hit_post', 'head_goal', 'pk_scored', 'fk_goal', 'thr_ball', 'misses', 'corners', 'crosses', \
                    'head_clear', 'blocks', 'interceptions', 'last_man', 'tackles', 'elg', 'own_goal', 'clears', 'yellow', \
                    'red', 'offsides', 'fouls']

    data = pd.DataFrame(matrix, columns = column_names)

    data.pop('id_1')
    data.pop('id_2')
    data.pop('id_3')

    label_encoder = LabelEncoder()

    categories = ['player_first_name', 'player_last_name', 'born', 'nation', 'season', 'squad', 'position']

    for category in categories:
        data[category] = label_encoder.fit_transform(data[category])

    new_column_names = ['player_first_name', 'player_last_name', 'born', 'nation', 'season', 'squad', \
                    'position', 'market_value', 'app', 'minutes', 'sub_on', 'sub_off', 'goals', 'passes', 'assists', 'shots', \
                    'sot', 'hit_post', 'head_goal', 'pk_scored', 'fk_goal', 'thr_ball', 'misses', 'corners', 'crosses', \
                    'head_clear', 'blocks', 'interceptions', 'last_man', 'tackles', 'elg', 'own_goal', 'clears', 'yellow', \
                    'red', 'offsides', 'fouls']

    data = pd.DataFrame(data, columns = new_column_names)

    features = data.drop(['market_value'], axis = 1)
    target = data['market_value']

    print("Connection Established")
    print()

    return features, target