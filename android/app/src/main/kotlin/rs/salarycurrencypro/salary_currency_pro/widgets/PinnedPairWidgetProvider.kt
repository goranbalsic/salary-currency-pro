package rs.salarycurrencypro.salary_currency_pro.widgets

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import rs.salarycurrencypro.salary_currency_pro.MainActivity
import rs.salarycurrencypro.salary_currency_pro.R

/**
 * Pinned currency-pair widget (PROMPT-003 Stage B item 8). The pair itself
 * is chosen in Settings ([rs.salarycurrencypro.salary_currency_pro] Dart
 * side, `PinnedPairService`); this class only renders whatever
 * `HomeWidgetService` last wrote. When the last refresh could not reach a
 * live rate (`pair_available` false), the previously-written rate/date text
 * is left in place — never replaced with a fabricated value — the widget
 * just doesn't visually flag staleness beyond that (no separate "stale"
 * badge, since a widget on a phone that's been offline for days is already
 * an implicit staleness signal to the user).
 */
class PinnedPairWidgetProvider : HomeWidgetProvider() {

  override fun onUpdate(
      context: Context,
      appWidgetManager: AppWidgetManager,
      appWidgetIds: IntArray,
      widgetData: SharedPreferences,
  ) {
    appWidgetIds.forEach { widgetId ->
      val views =
          RemoteViews(context.packageName, R.layout.pinned_pair_widget_layout).apply {
            val pendingIntent =
                HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java)
            setOnClickPendingIntent(R.id.pair_widget_container, pendingIntent)

            val from = widgetData.getString("pair_from_code", null)
            val to = widgetData.getString("pair_to_code", null)
            if (from != null && to != null) {
              setTextViewText(R.id.pair_widget_codes, "1 $from = ")
              setViewVisibility(R.id.pair_widget_codes, View.VISIBLE)
            } else {
              setTextViewText(R.id.pair_widget_codes, "")
            }

            val rate = widgetData.getString("pair_rate_text", null)
            val available = widgetData.getBoolean("pair_available", rate != null)
            if (rate != null && to != null) {
              setTextViewText(R.id.pair_widget_rate, "$rate $to")
              setViewVisibility(R.id.pair_widget_rate, View.VISIBLE)
            } else {
              setViewVisibility(R.id.pair_widget_rate, View.GONE)
            }
            if (!available) {
              setTextViewText(
                  R.id.pair_widget_unavailable,
                  widgetData.getString("pair_unavailable_label", null) ?: "",
              )
              setViewVisibility(R.id.pair_widget_unavailable, View.VISIBLE)
            } else {
              setViewVisibility(R.id.pair_widget_unavailable, View.GONE)
            }

            val asOf = widgetData.getString("pair_asof_text", null)
            setTextViewText(R.id.pair_widget_asof, asOf ?: "")
          }

      appWidgetManager.updateAppWidget(widgetId, views)
    }
  }
}
