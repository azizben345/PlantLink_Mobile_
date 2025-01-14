from django.urls import path
from . import views
urlpatterns = [
    path('', views.channels, name='channels'),
    path('create_channel/', views.create_channel, name='create_channel'),
    path('<str:channel_id>/', views.view_channel_sensor, name="view_channel_sensor"),
    path('<str:channel_id>/edit', views.edit_channel, name="edit_channel"),
    path('<str:channel_id>/delete', views.delete_channel, name="delete_channel"),
    path('<str:channel_id>/share', views.share_channel, name="share_channel"),
    
    # CONTROL SENSOR API PERMISSIONS
    path('<str:channel_id>/permit_API', views.permit_API, name="permit_API"),
    path('<str:channel_id>/forbid_API', views.forbid_API, name="forbid_API"),

    # RETRIEVE DASHBOARD DATA
    path('<str:channel_id>/get_dashboard_data/', views.getDashboardData, name="getDashboardData"),
    
    # RETRIEVE LATEST CROP SUGGESTION
    #path('<str:channel_id>/get_crop_suggestions/', views.getCropSuggestions, name='get_crop_suggestions'),

    # VIEW PUBLIC DASHBOARD OR EMBED
    path('<str:channel_id>/get_shared_dashboard', views.getSharedDashboardDetail, name="getSharedDashboardDetail"),
    
    # SHARE DASHBOARD , CHART , AND TABLE
    path('<str:channel_id>/shared_dashboard/', views.sharedDashboard, name="sharedDashboard"),
    path('embed/channel/<str:channel_id>/', views.render_embed_code, name='render_embed_code'),
    path('<str:channel_id>/share_chart/phChart/<str:start_date>/<str:end_date>/<str:chart_name>/', views.share_ph_chart, name="share_ph_chart"),
    path('<str:channel_id>/share_chart/humidityChart/<str:start_date>/<str:end_date>/<str:chart_name>/', views.share_humidity_chart, name="share_humidity_chart"),
    path('<str:channel_id>/share_chart/temperatureChart/<str:start_date>/<str:end_date>/<str:chart_name>/', views.share_temperature_chart, name="share_temperature_chart"),
    path('<str:channel_id>/share_chart/rainfallChart/<str:start_date>/<str:end_date>/<str:chart_name>/', views.share_rainfall_chart, name="share_rainfall_chart"),
    path('<str:channel_id>/share_chart/nitrogenChart/<str:start_date>/<str:end_date>/<str:chart_name>/', views.share_nitrogen_chart, name="share_nitrogen_chart"),
    path('<str:channel_id>/share_chart/potassiumChart/<str:start_date>/<str:end_date>/<str:chart_name>/', views.share_potassium_chart, name="share_potassium_chart"),
    path('<str:channel_id>/share_chart/phosphorousChart/<str:start_date>/<str:end_date>/<str:chart_name>/', views.share_phosphorous_chart, name="share_phosphorous_chart"),
    path('<str:channel_id>/share_table/cropTable/<str:start_date>/<str:end_date>/<str:table_name>/', views.share_crop_table, name="share_crop_table"),

    # RENDER CHART TEMPLATE
    # path('embed/channel/<str:channel_id>/phChart/<str:start_date>/<str:end_date>/', views.render_ph_chart, name='render_ph_chart'),
    # path('embed/channel/<str:channel_id>/humidityChart/<str:start_date>/<str:end_date>/', views.render_humidity_chart, name='render_humidity_chart'),
    # path('embed/channel/<str:channel_id>/temperatureChart/<str:start_date>/<str:end_date>/', views.render_temperature_chart, name='render_temperature_chart'),
    # path('embed/channel/<str:channel_id>/nitrogenChart/<str:start_date>/<str:end_date>/', views.render_nitrogen_chart, name='render_nitrogen_chart'),
    # path('embed/channel/<str:channel_id>/phosphorousChart/<str:start_date>/<str:end_date>/', views.render_phosphorous_chart, name='render_phosphorous_chart'),
    # path('embed/channel/<str:channel_id>/potassiumChart/<str:start_date>/<str:end_date>/', views.render_potassium_chart, name='render_potassium_chart'),
    # path('embed/channel/<str:channel_id>/rainfallChart/<str:start_date>/<str:end_date>/', views.render_rainfall_chart, name='render_rainfall_chart'),
    # path('embed/channel/<str:channel_id>/cropTable/<str:start_date>/<str:end_date>/', views.render_crop_table_by_date, name='render_crop_table_by_date'),

    # RENDER CHART BASED ON TIMEFRAME
    path('ph_data/<str:channel_id>/<str:start_date>/<str:end_date>/', views.getPHData, name='get_ph_data'),
    path('humidity_temperature/<str:channel_id>/<str:start_date>/<str:end_date>/', views.getHumidityTemperatureData, name='getHumidityTemperatureData'),
    path('NPK/<str:channel_id>/<str:start_date>/<str:end_date>/', views.getNPKData, name='getNPKData'),
    path('rainfall_data/<str:channel_id>/<str:start_date>/<str:end_date>/', views.getRainfallData, name='getRainfallData'),
    #path('<str:channel_id>/getCropRecommendationByDate/<str:start_date>/<str:end_date>/', views.getCropRecommendationByDate, name='getCropRecommendationByDate'),

    path('<str:channel_id>/manage_sensor', views.manage_sensor, name="manage_sensor"),

    path('<str:channel_id>/edit_sensor/<str:sensor_type>/<str:sensor_id>/', views.edit_sensor, name="edit_sensor"),
    path('<str:channel_id>/add_sensor', views.add_sensor, name="add_sensor"),
    path('<str:channel_id>/unset_sensor', views.unset_sensor, name="unset_sensor"),
    path('<str:channel_id>/delete_sensor/<str:sensor_type>/', views.delete_sensor, name="delete_sensor"),
]