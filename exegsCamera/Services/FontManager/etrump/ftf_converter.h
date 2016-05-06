#ifndef __ET_CONVERTER_H__
#define __ET_CONVERTER_H__

#ifdef __cplusplus
extern "C" {
#endif

#define ERROR_OK                                0
#define ERROR_OUT_OF_MEMORY                     0x4001
#define ERROR_OPEN_FILE_FAIL                    0x4002
#define ERROR_BAD_PARAMETER                     0x4004
#define ERROR_BAD_TTF_FILE                      0x4008
#define ERROR_EMPTY_FILE                        0x4009
#define ERROR_SEEK_FILE_FAIL                    0x400A
#define ERROR_READ_FILE_FAIL                    0x400B
#define ERROR_WRITE_FILE_FAIL                   0x400C

#define ERROR_INVALID_NUM_OF_METRICS            0x4010
#define ERROR_HEAD_TABLE_MISSING                0x4020
#define ERROR_CMAP_TABLE_MISSING                0x4021
#define ERROR_HMTX_TABLE_MISSING                0x4022
#define ERROR_LOCA_TABLE_MISSING                0x4023
#define ERROR_GLYF_TABLE_MISSING                0x4024

#define ERROR_TOO_BIG_OUTLINE_SIZE              0x4030
#define ERROR_DIFFERENT_OUTLINE                 0x4031
#define ERROR_UNICODES_NOT_SPECIFIED            0x4032

#define ERROR_IS_NOT_FULLTYPE_FONT				0x4040     // 传入的字库不是fulltype字库，转换结束

typedef void                ET_Void;
typedef signed int          ET_Long;
typedef unsigned int        ET_ULong;
typedef int                 ET_Int;
typedef unsigned int        ET_UInt;
typedef unsigned short      ET_WChar;
typedef short               ET_Short;
typedef unsigned short      ET_UShort;
typedef unsigned char       ET_Byte;
typedef char                ET_Char;
typedef int                 ET_Bool;
typedef int                 ET_Error;

#define ET_False        0
#define ET_True         1


#define ET_CONVERTER_REUSE_TTF_GLYPH_FLAG           0x0001
#define ET_CONVERTER_LOAD_FTF_FROM_MEMORY_FLAG      0x0002
#define ET_CONVERTER_LOAD_TTF_FROM_MEMORY_FLAG      0x0004
#define ET_CONVERTER_FORCE_SUPPORT_MAC_OS           0x0008
#define ET_CONVERTER_GLYPH_CACHE_SIZE_MASK          0x00F0
#define ET_CONVERTER_CHECK_OUTLINE_FLAG             0x0100

/* ftf to ttf font */
ET_Error
ET_Converter_FTF_To_TTF( const ET_Char * ftf_file_path,
                         const ET_Char * ttf_file_path,
                         const ET_WChar * unicodes,
                         ET_Int unicodes_count,
                         ET_Int flags );

/* check the object font file */
ET_Error
ET_Converter_Check_TTF_With_FTF( const ET_Char * ftf_file_path,
                                 const ET_Char * ttf_file_path,
                                 const ET_WChar * unicodes,
                                 ET_Int unicodes_count,
                                 ET_Int flags );


/* ftf to ttf font from memory */
ET_Error
ET_Converter_FTF_To_TTF_Ex( const ET_Byte * ftf_base,
                            ET_Long ftf_size,
                            const ET_Char * ttf_file_path,
                            const ET_WChar * unicodes,
                            ET_Int unicodes_count,
                            ET_Int flags );

/* check the object font file with ftf from memory */
ET_Error
ET_Converter_Check_TTF_With_FTF_Ex( const ET_Byte * ftf_base,
                                    ET_Long ftf_size,
                                    const ET_Char * ttf_file_path,
                                    const ET_WChar * unicodes,
                                    ET_Int unicodes_count,
                                    ET_Int flags );


#ifdef __cplusplus
}
#endif /* __CPLUSPLUS */

#endif /* __ET_CONVERTER_H__ */

