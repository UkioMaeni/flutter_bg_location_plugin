package com.ezride.flutter_bg_location_plugin.services

import android.content.Context
import android.content.SharedPreferences

class LocationStorage(context: Context) {
    companion object {
        private const val PREFS_NAME = "bg_loc_prefs"                   // идентификатор преференса
        private const val KEY_HASH = "hash"                             // ключ хэша по которому будет отправляться данные на сервер
        private const val KEY_TICKER_SECONDS = "ticker_seconds"         // ключ секунд для 1 тика 
        private const val DEFAULT_TICKER_SECONDS = 10                   // дефолтное значение секунд для 1 тика 
        private const val KEY_TICKERS_LEFT = "tickers_left"             // ключ сколько осталось тикеров
        private const val KEY_TICKER_ID = "ticker_id"                   // ключ id тикера к чему он подвязан если активен
        private const val KEY_ORDER_ID = "order_id"                     // ключ id ордера к чему он подвязан если активен
        
    }
    private val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)


    //////////////Хэш
    // запрос хэша
    fun getHash(): String? = prefs.getString(KEY_HASH, "");
    //сохранение хэша
    fun setHash(hash: String) {
        prefs.edit().putString(KEY_HASH, hash).apply();
    }

    //////////////Тикер секунд
    // запрос секунд на 1 тикер 
    fun getTickerSeconds(): Int = prefs.getInt(KEY_TICKER_SECONDS, DEFAULT_TICKER_SECONDS);
    //сохранение тикера секунд
    fun setTickerSeconds(tickerSeconds: Int) {
        prefs.edit().putInt(KEY_TICKER_SECONDS, tickerSeconds).apply()
    }

    //////////////Колличественное свойство тикеров
    // запрос тикеров 
    fun getTickers(): Int = prefs.getInt(KEY_TICKERS_LEFT, 0);
    //сохранение тикеров
    fun setTickers(tickerCount: Int) {
        prefs.edit().putInt(KEY_TICKERS_LEFT, tickerCount).apply()
    }
    //уменьшение тикера на 1
    fun declineOneTickers() {
        val tickers = getTickers();
        prefs.edit().putInt(KEY_TICKERS_LEFT, tickers-1).apply()
    }

    //////////////Подвязка тикера локации к данным
    // запрос айди 
    fun getTickerId(): String? = prefs.getString(KEY_TICKER_ID, "");
    //сохранение айди тикера
    fun setTickerId(tickerId : String) {
        prefs.edit().putString(KEY_TICKER_ID, tickerId).apply()
    }

    //////////////Подвязка тикера локации к данным
    // запрос айди 
    fun getOrderId(): Int = prefs.getInt(KEY_ORDER_ID, 0);
    //сохранение айди тикера
    fun setOrderId(orderId : Int) {
        prefs.edit().putInt(KEY_ORDER_ID, orderId).apply()
    }
}