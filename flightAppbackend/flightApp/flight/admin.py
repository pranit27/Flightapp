from django.contrib import admin

from .models import Flight

@admin.register(Flight)
class FlightAdmin(admin.ModelAdmin):
	list_display = ('flight_number', 'departure_city', 'arrival_city', 'departure_time','arrival_time')
	search_fields = ('flight_number', 'departure_city', 'arrival_city', 'departure_time','arrival_time')