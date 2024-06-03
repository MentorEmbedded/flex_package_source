// This file was generated by gir (https://github.com/gtk-rs/gir)
// from gir-files (https://github.com/gtk-rs/gir-files)
// DO NOT EDIT

use crate::SettingsSchema;
use glib::translate::*;
use std::ptr;

glib::wrapper! {
    #[derive(Debug, PartialEq, Eq, PartialOrd, Ord, Hash)]
    pub struct SettingsSchemaSource(Shared<ffi::GSettingsSchemaSource>);

    match fn {
        ref => |ptr| ffi::g_settings_schema_source_ref(ptr),
        unref => |ptr| ffi::g_settings_schema_source_unref(ptr),
        type_ => || ffi::g_settings_schema_source_get_type(),
    }
}

impl SettingsSchemaSource {
    #[doc(alias = "g_settings_schema_source_new_from_directory")]
    #[doc(alias = "new_from_directory")]
    pub fn from_directory<P: AsRef<std::path::Path>>(
        directory: P,
        parent: Option<&SettingsSchemaSource>,
        trusted: bool,
    ) -> Result<SettingsSchemaSource, glib::Error> {
        unsafe {
            let mut error = ptr::null_mut();
            let ret = ffi::g_settings_schema_source_new_from_directory(
                directory.as_ref().to_glib_none().0,
                parent.to_glib_none().0,
                trusted.into_glib(),
                &mut error,
            );
            if error.is_null() {
                Ok(from_glib_full(ret))
            } else {
                Err(from_glib_full(error))
            }
        }
    }

    #[doc(alias = "g_settings_schema_source_list_schemas")]
    pub fn list_schemas(&self, recursive: bool) -> (Vec<glib::GString>, Vec<glib::GString>) {
        unsafe {
            let mut non_relocatable = ptr::null_mut();
            let mut relocatable = ptr::null_mut();
            ffi::g_settings_schema_source_list_schemas(
                self.to_glib_none().0,
                recursive.into_glib(),
                &mut non_relocatable,
                &mut relocatable,
            );
            (
                FromGlibPtrContainer::from_glib_full(non_relocatable),
                FromGlibPtrContainer::from_glib_full(relocatable),
            )
        }
    }

    #[doc(alias = "g_settings_schema_source_lookup")]
    pub fn lookup(&self, schema_id: &str, recursive: bool) -> Option<SettingsSchema> {
        unsafe {
            from_glib_full(ffi::g_settings_schema_source_lookup(
                self.to_glib_none().0,
                schema_id.to_glib_none().0,
                recursive.into_glib(),
            ))
        }
    }

    #[doc(alias = "g_settings_schema_source_get_default")]
    #[doc(alias = "get_default")]
    pub fn default() -> Option<SettingsSchemaSource> {
        unsafe { from_glib_none(ffi::g_settings_schema_source_get_default()) }
    }
}
