package com.example.todoai_flutter  // your package name
import android.util.Log
import android.appwidget.AppWidgetManager
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import com.example.todoai_flutter.R
import org.json.JSONException
import android.content.Intent
import android.widget.RemoteViewsService
import org.json.JSONObject
import org.json.JSONArray as OrgJSONArray
import android.content.Context



class HomeScreenWidgetProvider : HomeWidgetProvider() {
     override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_layout).apply {
                // Open App on Widget Click
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(context,
                        MainActivity::class.java)
                        
                setOnClickPendingIntent(R.id.widget_root, pendingIntent) 

                setTextViewText(R.id.textViewDate, widgetData.getString("date", null)
                        ?: "No date Set") 

                            
                
                // Đọc JSON từ SharedPreferences và chuyển đổi thành danh sách Task
            val tasksJsonString = widgetData.getString("tasks", null)



                // Cập nhật GridView

               val intent = Intent(context, ListViewRemoteViewsService::class.java).apply {
                putExtra("tasksJsonString", tasksJsonString)
                data = Uri.parse(toUri(Intent.URI_INTENT_SCHEME))
                }
                setRemoteAdapter(R.id.widget_listview, intent)
                val listViewPendingIntentTemplate = HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java, Uri.parse("examplehomewidget://mainactivity"))

                setPendingIntentTemplate(R.id.widget_listview, listViewPendingIntentTemplate)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
    
}
class ListViewRemoteViewsFactory(
    private val context: Context,
    private val tasksJsonString: String? 
) : RemoteViewsService.RemoteViewsFactory {

    private val tasks = mutableListOf<Task>()

    override fun onCreate() {}

    override fun onDataSetChanged() {
        if (tasksJsonString != null) {
            try {
                val jsonArray = OrgJSONArray(tasksJsonString as String)
                for (i in 0 until jsonArray.length()) {
                    tasks.add(Task.fromJson(jsonArray.getJSONObject(i)))
                }
            } catch (e: JSONException) {
                e.printStackTrace()
            }
        }
    }

    override fun onDestroy() {}

    override fun getCount(): Int = tasks.size

    override fun getViewAt(position: Int): RemoteViews {
        val task = tasks[position]

        val taskView = RemoteViews(context.packageName, R.layout.task_item)
        taskView.setTextViewText(R.id.task_title, task.title)
        taskView.setTextViewText(R.id.task_time, task.time)

        return taskView
    }

    override fun getLoadingView(): RemoteViews? = null

    override fun getViewTypeCount(): Int = 1

    override fun getItemId(position: Int): Long = position.toLong()

    override fun hasStableIds(): Boolean = true
}
class ListViewRemoteViewsService : RemoteViewsService() {

    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        val tasksJsonString = intent.getStringExtra("tasksJsonString")
        return ListViewRemoteViewsFactory(applicationContext, tasksJsonString)
    }
}


data class Task(val title: String, val time: String) {
    companion object {
        fun fromJson(json: JSONObject): Task {
            val title = json.optString("title", "")
            val time = json.optString("time", "")
            return Task(title, time)
        }
    }
}