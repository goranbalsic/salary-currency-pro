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
 * Spend-vs-budget summary widget (PROMPT-003 Stage B item 8). All text is
 * written by [rs.salarycurrencypro.salary_currency_pro] Dart code (see
 * `lib/services/home_widget_service.dart`) via the `home_widget` plugin's
 * shared storage — this class only lays out whatever was last pushed, in
 * the user's own app language, and never computes or formats numbers
 * itself.
 */
class BudgetWidgetProvider : HomeWidgetProvider() {

  override fun onUpdate(
      context: Context,
      appWidgetManager: AppWidgetManager,
      appWidgetIds: IntArray,
      widgetData: SharedPreferences,
  ) {
    appWidgetIds.forEach { widgetId ->
      val views =
          RemoteViews(context.packageName, R.layout.budget_widget_layout).apply {
            val pendingIntent =
                HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java)
            setOnClickPendingIntent(R.id.budget_widget_container, pendingIntent)

            val hasData = widgetData.getBoolean("budget_has_data", false)
            if (hasData) {
              setViewVisibility(R.id.budget_widget_content, View.VISIBLE)
              setViewVisibility(R.id.budget_widget_empty, View.GONE)
              setTextViewText(
                  R.id.budget_widget_label,
                  widgetData.getString("budget_label", null) ?: "",
              )
              val spent = widgetData.getString("budget_spent_text", null) ?: "—"
              val limit = widgetData.getString("budget_limit_text", null) ?: "—"
              val currency = widgetData.getString("budget_currency", null) ?: ""
              setTextViewText(R.id.budget_widget_amounts, "$spent / $limit $currency")
              setTextViewText(
                  R.id.budget_widget_percent,
                  widgetData.getString("budget_percent_text", null) ?: "",
              )
            } else {
              setViewVisibility(R.id.budget_widget_content, View.GONE)
              setViewVisibility(R.id.budget_widget_empty, View.VISIBLE)
              setTextViewText(
                  R.id.budget_widget_empty,
                  widgetData.getString("budget_empty_label", null)
                      ?: "Set a budget in the app to see it here",
              )
            }
          }

      appWidgetManager.updateAppWidget(widgetId, views)
    }
  }
}
