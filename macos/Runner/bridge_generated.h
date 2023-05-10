#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
typedef struct _Dart_Handle* Dart_Handle;

/**
 * A 48-bit (6 byte) buffer containing the EUI address
 */
#define EUI48LEN 6

/**
 * A 64-bit (8 byte) buffer containing the EUI address
 */
#define EUI64LEN 8

#define X0 0

#define X1 1

#define X2 2

#define X3 3

#define X4 4

#define X5 5

#define X6 6

#define X7 7

#define X8 8

#define X9 9

#define X10 10

#define X11 11

#define X12 12

#define X13 13

#define X14 14

#define X15 15

#define X16 16

#define X17 17

#define X18 18

#define X19 19

#define X20 20

#define D20 2196

#define D21 2197

#define D22 2198

#define D23 2199

#define D24 2200

#define D25 2201

#define D26 2202

#define D27 2203

#define D28 2204

#define D29 2205

#define D30 2206

#define D31 2207

#define D32 2208

#define D33 2209

#define D34 2210

#define D35 2211

#define D36 2212

#define D37 2213

#define D38 2214

#define D39 2215

#define D40 2216

#define D41 2217

#define D42 2218

#define D43 2219

#define D44 2220

#define D45 2221

#define D46 2222

#define D47 2223

#define D48 2224

#define D49 2225

#define D50 2226

#define D51 2227

#define D52 2228

#define D53 2229

#define D54 2230

#define D55 2231

#define D56 2232

#define D57 2233

#define D58 2234

#define D59 2235

#define D60 2236

#define D61 2237

#define D62 2238

#define D63 2239

#define D64 2240

#define D65 2241

#define D66 2242

#define D67 2243

#define D68 2244

#define D69 2245

#define D70 2246

#define D71 2247

#define D72 2248

#define D73 2249

#define D74 2250

#define D75 2251

#define D76 2252

#define D77 2253

#define D78 2254

#define D79 2255

#define D80 2256

#define D81 2257

#define D82 2258

#define D83 2259

#define D84 2260

#define D85 2261

#define D86 2262

#define D87 2263

#define D88 2264

#define D89 2265

#define D90 2266

#define D91 2267

#define D92 2268

#define D93 2269

#define D94 2270

#define D95 2271

#define D96 2272

#define D97 2273

#define D98 2274

typedef struct DartCObject DartCObject;

typedef int64_t DartPort;

typedef bool (*DartPostCObjectFnType)(DartPort port_id, void *message);

typedef struct wire_uint_8_list {
  uint8_t *ptr;
  int32_t len;
} wire_uint_8_list;

typedef struct wire_Com {
  uint32_t field0;
} wire_Com;

typedef struct DartCObject *WireSyncReturn;

void store_dart_post_cobject(DartPostCObjectFnType ptr);

Dart_Handle get_dart_object(uintptr_t ptr);

void drop_dart_object(uintptr_t ptr);

uintptr_t new_dart_opaque(Dart_Handle handle);

intptr_t init_frb_dart_api_dl(void *obj);

void wire_ble_validate_response(int64_t port_, struct wire_uint_8_list *data);

void wire_ble_response_parse_u16(int64_t port_, struct wire_uint_8_list *data);

void wire_ble_response_parse_bool(int64_t port_, struct wire_uint_8_list *data);

void wire_ble_get_ndid(int64_t port_);

void wire_ble_at_ndrpt(int64_t port_,
                       struct wire_uint_8_list *id,
                       struct wire_uint_8_list *data,
                       uint8_t retry);

void wire_ble_at_ndrpt_data(int64_t port_,
                            struct wire_uint_8_list *id,
                            struct wire_uint_8_list *data,
                            uint8_t retry);

void wire_ble_at_ndrpt_test(int64_t port_);

void wire_ble_set_ndid(int64_t port_, struct wire_uint_8_list *id);

void wire_ble_set_mode(int64_t port_, uint8_t mode);

void wire_ble_ndreset(int64_t port_);

void wire_ble_restore(int64_t port_);

void wire_ble_reboot(int64_t port_);

void wire_ble_scan(int64_t port_, uint8_t typee);

void wire_ble_lecconn(int64_t port_, struct wire_uint_8_list *addr, uint8_t add_type);

void wire_ble_lecconn_addr(int64_t port_, struct wire_uint_8_list *addr);

void wire_ble_ledisc(int64_t port_, uint8_t index);

void wire_ble_lesend(int64_t port_, uint8_t index, struct wire_uint_8_list *data);

void wire_ble_chinfo(int64_t port_);

void wire_hal_generate_get_holdings(int64_t port_, uint8_t unit_id, uint16_t reg, uint16_t count);

void wire_hal_generate_get_coils(int64_t port_, uint8_t unit_id, uint16_t reg, uint16_t count);

void wire_hal_generate_set_coils(int64_t port_,
                                 uint8_t unit_id,
                                 uint16_t reg,
                                 struct wire_uint_8_list *values);

void wire_hal_generate_set_holding(int64_t port_, uint8_t unit_id, uint16_t reg, uint16_t value);

void wire_hex_encode(int64_t port_, struct wire_uint_8_list *data);

void wire_hex_decode(int64_t port_, struct wire_uint_8_list *data);

void wire_hal_new_control(int64_t port_,
                          uint8_t index,
                          uint8_t scene,
                          struct wire_Com *com_in,
                          struct wire_Com *com_out);

void wire_hal_control(int64_t port_,
                      uint8_t unit_id,
                      uint8_t index,
                      uint8_t scene,
                      struct wire_uint_8_list *v1,
                      struct wire_uint_8_list *v2,
                      struct wire_uint_8_list *v3,
                      struct wire_uint_8_list *v4,
                      struct wire_uint_8_list *v5,
                      struct wire_uint_8_list *v6);

void wire_hal_display_com(int64_t port_, struct wire_Com *com);

void wire_hal_new_com(int64_t port_, uint32_t value);

void wire_hal_get_com_indexs(int64_t port_, struct wire_uint_8_list *indexs);

void wire_hal_read_logic_control(int64_t port_,
                                 struct wire_uint_8_list *id,
                                 uint8_t retry,
                                 uint8_t index);

struct wire_Com *new_box_autoadd_com_0(void);

struct wire_uint_8_list *new_uint_8_list_0(int32_t len);

void free_WireSyncReturn(WireSyncReturn ptr);

static int64_t dummy_method_to_enforce_bundling(void) {
    int64_t dummy_var = 0;
    dummy_var ^= ((int64_t) (void*) wire_ble_validate_response);
    dummy_var ^= ((int64_t) (void*) wire_ble_response_parse_u16);
    dummy_var ^= ((int64_t) (void*) wire_ble_response_parse_bool);
    dummy_var ^= ((int64_t) (void*) wire_ble_get_ndid);
    dummy_var ^= ((int64_t) (void*) wire_ble_at_ndrpt);
    dummy_var ^= ((int64_t) (void*) wire_ble_at_ndrpt_data);
    dummy_var ^= ((int64_t) (void*) wire_ble_at_ndrpt_test);
    dummy_var ^= ((int64_t) (void*) wire_ble_set_ndid);
    dummy_var ^= ((int64_t) (void*) wire_ble_set_mode);
    dummy_var ^= ((int64_t) (void*) wire_ble_ndreset);
    dummy_var ^= ((int64_t) (void*) wire_ble_restore);
    dummy_var ^= ((int64_t) (void*) wire_ble_reboot);
    dummy_var ^= ((int64_t) (void*) wire_ble_scan);
    dummy_var ^= ((int64_t) (void*) wire_ble_lecconn);
    dummy_var ^= ((int64_t) (void*) wire_ble_lecconn_addr);
    dummy_var ^= ((int64_t) (void*) wire_ble_ledisc);
    dummy_var ^= ((int64_t) (void*) wire_ble_lesend);
    dummy_var ^= ((int64_t) (void*) wire_ble_chinfo);
    dummy_var ^= ((int64_t) (void*) wire_hal_generate_get_holdings);
    dummy_var ^= ((int64_t) (void*) wire_hal_generate_get_coils);
    dummy_var ^= ((int64_t) (void*) wire_hal_generate_set_coils);
    dummy_var ^= ((int64_t) (void*) wire_hal_generate_set_holding);
    dummy_var ^= ((int64_t) (void*) wire_hex_encode);
    dummy_var ^= ((int64_t) (void*) wire_hex_decode);
    dummy_var ^= ((int64_t) (void*) wire_hal_new_control);
    dummy_var ^= ((int64_t) (void*) wire_hal_control);
    dummy_var ^= ((int64_t) (void*) wire_hal_display_com);
    dummy_var ^= ((int64_t) (void*) wire_hal_new_com);
    dummy_var ^= ((int64_t) (void*) wire_hal_get_com_indexs);
    dummy_var ^= ((int64_t) (void*) wire_hal_read_logic_control);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_com_0);
    dummy_var ^= ((int64_t) (void*) new_uint_8_list_0);
    dummy_var ^= ((int64_t) (void*) free_WireSyncReturn);
    dummy_var ^= ((int64_t) (void*) store_dart_post_cobject);
    dummy_var ^= ((int64_t) (void*) get_dart_object);
    dummy_var ^= ((int64_t) (void*) drop_dart_object);
    dummy_var ^= ((int64_t) (void*) new_dart_opaque);
    return dummy_var;
}
