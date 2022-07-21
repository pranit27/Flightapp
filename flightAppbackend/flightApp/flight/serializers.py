from rest_framework import serializers
from .models import Flight


class FlightSerializer(serializers.ModelSerializer):
    class Meta:
        model = Flight
        fields = (
            "id",
            "flight_number",
            "departure_city",
            "arrival_city",
            "departure_time",
            "arrival_time"
        )