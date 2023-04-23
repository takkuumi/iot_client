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

typedef struct DartCObject *WireSyncReturn;

void store_dart_post_cobject(DartPostCObjectFnType ptr);

Dart_Handle get_dart_object(uintptr_t ptr);

void drop_dart_object(uintptr_t ptr);

uintptr_t new_dart_opaque(Dart_Handle handle);

intptr_t init_frb_dart_api_dl(void *obj);

void wire_get_ndid(int64_t port_);

void wire_at_ndrpt(int64_t port_,
                   struct wire_uint_8_list *id,
                   struct wire_uint_8_list *data,
                   uint8_t retry);

void wire_at_ndrpt_test(int64_t port_);

void wire_set_ndid(int64_t port_, struct wire_uint_8_list *id);

void wire_set_mode(int64_t port_, uint8_t mode);

void wire_ndreset(int64_t port_);

void wire_restore(int64_t port_);

void wire_reboot(int64_t port_);

void wire_print_a(int64_t port_);

struct wire_uint_8_list *new_uint_8_list_0(int32_t len);

void free_WireSyncReturn(WireSyncReturn ptr);

static int64_t dummy_method_to_enforce_bundling(void) {
    int64_t dummy_var = 0;
    dummy_var ^= ((int64_t) (void*) wire_get_ndid);
    dummy_var ^= ((int64_t) (void*) wire_at_ndrpt);
    dummy_var ^= ((int64_t) (void*) wire_at_ndrpt_test);
    dummy_var ^= ((int64_t) (void*) wire_set_ndid);
    dummy_var ^= ((int64_t) (void*) wire_set_mode);
    dummy_var ^= ((int64_t) (void*) wire_ndreset);
    dummy_var ^= ((int64_t) (void*) wire_restore);
    dummy_var ^= ((int64_t) (void*) wire_reboot);
    dummy_var ^= ((int64_t) (void*) wire_print_a);
    dummy_var ^= ((int64_t) (void*) new_uint_8_list_0);
    dummy_var ^= ((int64_t) (void*) free_WireSyncReturn);
    dummy_var ^= ((int64_t) (void*) store_dart_post_cobject);
    dummy_var ^= ((int64_t) (void*) get_dart_object);
    dummy_var ^= ((int64_t) (void*) drop_dart_object);
    dummy_var ^= ((int64_t) (void*) new_dart_opaque);
    return dummy_var;
}
