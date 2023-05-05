#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
typedef struct _Dart_Handle* Dart_Handle;

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

void wire_ble_response_parse_u16(int64_t port_, struct wire_uint_8_list *data, uint8_t unit_id);

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

void wire_ble_lecconn2(int64_t port_, struct wire_uint_8_list *addr, uint8_t add_type);

void wire_ble_lecconn_addr(int64_t port_, struct wire_uint_8_list *addr);

void wire_ble_lesend(int64_t port_, uint8_t index, struct wire_uint_8_list *data);

void wire_ble_chinfo(int64_t port_);

void wire_hal_generate_get_holdings(int64_t port_, uint8_t unit_id, uint16_t reg, uint16_t count);

void wire_hal_generate_set_holding(int64_t port_, uint8_t unit_id, uint16_t reg, uint16_t value);

void wire_hex_encode(int64_t port_, struct wire_uint_8_list *data);

void wire_hex_decode(int64_t port_, struct wire_uint_8_list *data);

void wire_hal_new_control(int64_t port_,
                          struct wire_uint_8_list *id,
                          uint8_t retry,
                          uint8_t index,
                          uint8_t scene,
                          struct wire_Com *com_in,
                          struct wire_Com *com_out);

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
    dummy_var ^= ((int64_t) (void*) wire_ble_lecconn2);
    dummy_var ^= ((int64_t) (void*) wire_ble_lecconn_addr);
    dummy_var ^= ((int64_t) (void*) wire_ble_lesend);
    dummy_var ^= ((int64_t) (void*) wire_ble_chinfo);
    dummy_var ^= ((int64_t) (void*) wire_hal_generate_get_holdings);
    dummy_var ^= ((int64_t) (void*) wire_hal_generate_set_holding);
    dummy_var ^= ((int64_t) (void*) wire_hex_encode);
    dummy_var ^= ((int64_t) (void*) wire_hex_decode);
    dummy_var ^= ((int64_t) (void*) wire_hal_new_control);
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
