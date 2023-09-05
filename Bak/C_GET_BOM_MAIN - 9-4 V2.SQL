/* Formatted on 2023/9/1 下午 04:40:06 (QP5 v5.256.13226.35538) */
CREATE OR REPLACE PROCEDURE sfis1.c_getbom_main (i_sn         IN     VARCHAR2,
                                                 i_customer   IN     VARCHAR2,
                                                 i_plant      IN     VARCHAR2,
                                                 i_line       IN     VARCHAR2,
                                                 i_group      IN     VARCHAR2,
                                                 i_vendor     IN     VARCHAR2,
                                                 o_status        OUT VARCHAR2,
                                                 o_msg           OUT VARCHAR2,
                                                 content1        OUT VARCHAR2,
                                                 content2        OUT VARCHAR2)
AS
   c_count NUMBER;
   q_sn VARCHAR2 (30);
   m_content1 VARCHAR2 (5000);
   m_content2 VARCHAR2 (5000);
BEGIN
   sfis1.c_getbom_check_sn (i_sn, o_status, o_msg, q_sn, m_content1);
   content1 := content1 || m_content1;

   IF o_status = 'PASS'
   THEN
      sfis1.c_getbom_sn_info (q_sn, i_group, o_status, o_msg, m_content1);
      content1 := content1 || m_content1;
      sfis1.c_getbom_secondmac (q_sn, o_status, o_msg, m_content1);
      content1 := content1 || m_content1;
      sfis1.c_getbom_fprint (q_sn, o_status, o_msg, m_content1);
      content1 := content1 || m_content1;
      sfis1.c_getbom_smart_card (q_sn, o_status, o_msg, m_content1);
      content1 := content1 || m_content1;
      sfis1.c_getbom_rfid (q_sn, o_status, o_msg, m_content1);
      content1 := content1 || m_content1;
      c_getbom_cover_color (q_sn, o_status, o_msg, m_content1);
      content1 := content1 || m_content1;
      sfis1.c_getbom_sp_button (q_sn, o_status, o_msg, m_content1);
      content1 := content1 || m_content1;
      sfis1.c_getbom_nfc (q_sn, o_status, o_msg, m_content1);
      content1 := content1 || m_content1;
      sfis1.c_getbom_camera (q_sn, o_status, o_msg, m_content1, m_content2);
      content1 := content1 || m_content1;
      content2 := content2 || m_content2;
      sfis1.c_getbom_lcd (q_sn, o_status, o_msg, m_content1);
      content1 := content1 || m_content1;
      sfis1.c_getbom_lcdfw (q_sn, o_status, o_msg, m_content1);
      content1 := content1 || m_content1;
      sfis1.c_getbom_psensor (q_sn, o_status, o_msg, m_content1);
      content1 := content1 || m_content1;
      sfis1.c_getbom_mic (q_sn, o_status, o_msg, m_content1);
      content1 := content1 || m_content1;
      sfis1.c_getbom_power_cable (q_sn, o_status, o_msg, m_content1);
      content1 := content1 || m_content1;
      sfis1.c_getbom_kb (q_sn, o_status, o_msg, m_content1);
      content1 := content1 || m_content1;
      sfis1.c_getbom_battcap (q_sn, o_status, o_msg, m_content1);
      content1 := content1 || m_content1;
      sfis1.c_getbom_lan_b (q_sn, o_status, o_msg, m_content1);
      content1 := content1 || m_content1;
      sfis1.c_getbom_ram (q_sn, o_status, o_msg, m_content1, m_content2);
      content1 := content1 || m_content1;
      content2 := content2 || m_content2;
      sfis1.c_getbom_hdd (q_sn, o_status, o_msg, m_content1, m_content2);
      content1 := content1 || m_content1;
      content2 := content2 || m_content2;
      sfis1.c_getbom_cpu (q_sn, o_status, o_msg, m_content1);
      content1 := content1 || m_content1;
      sfis1.c_getbom_odd (q_sn, o_status, o_msg, m_content1);
      content1 := content1 || m_content1;
      sfis1.c_getbom_blue (q_sn, o_status, o_msg, m_content1);
      content1 := content1 || m_content1;
      sfis1.c_getbom_wlan (q_sn, o_status, o_msg, m_content1);
      content1 := content1 || m_content1;
      sfis1.c_getbom_gps (q_sn, o_status, o_msg, m_content1);
      content1 := content1 || m_content1;
      sfis1.c_getbom_iob (q_sn, o_status, o_msg, m_content1);
      content1 := content1 || m_content1;
      sfis1.c_getbom_modem (q_sn, o_status, o_msg, m_content1);
      content1 := content1 || m_content1;
      sfis1.c_getbom_express_card (q_sn, o_status, o_msg, m_content1);
      content1 := content1 || m_content1;
      sfis1.c_getbom_tvt (q_sn, o_status, o_msg, m_content1);
      content1 := content1 || m_content1;
   ELSE
      o_status := 'FAIL';
      o_msg := 'Check SN FAIL';
      RETURN;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      o_status := 'FAIL';
      o_msg := 'Error code :' || SQLCODE || ', Message :' || SUBSTR (SQLERRM, 1, 200);
END;

CREATE OR REPLACE PROCEDURE sfis1.c_getbom_check_sn (
   i_sn       IN     VARCHAR2,
   o_status      OUT VARCHAR2,
   o_msg         OUT VARCHAR2,
   o_sn          OUT VARCHAR2,
   content1      OUT VARCHAR2)
AS
   c_count NUMBER;
BEGIN
   content1 := NULL;

   SELECT COUNT (*)
     INTO c_count
     FROM sfism4.r_wip_tracking_t w, sfism4.r_wip_keyparts_t k1,
          sfism4.r_wip_keyparts_t k2, sfism4.r_part_map_t t
    WHERE     k2.serial_number = w.serial_number
          AND k1.key_part_sn = t.compal_sn
          AND k2.key_part_sn = k1.serial_number
          AND t.lan_address = i_sn;

   IF c_count = 0
   THEN
      SELECT COUNT (*)
        INTO c_count
        FROM sfism4.r_wip_tracking_t w, sfism4.r_wip_keyparts_t k,
             sfism4.r_part_map_t t
       WHERE     k.serial_number = w.serial_number
             AND k.key_part_sn = t.compal_sn
             AND t.lan_address = i_sn;

      IF c_count = 0
      THEN
         IF LENGTH (TRIM (i_sn)) = 13
         THEN
            SELECT COUNT (wt.serial_number)
              INTO c_count
              FROM sfism4.r_wip_tracking_t wt
             WHERE wt.serial_number = TRIM (i_sn);

            IF c_count = 0
            THEN
               o_status := 'FAIL';
               o_msg :=
                  o_msg || 'SN not exist, pls check' || CHR (13) || CHR (10);
               content1 := 'SET RESULT=FAIL' || CHR (13) || CHR (10);
               content1 :=
                  content1 || 'SET REASON=' || o_msg || CHR (13) || CHR (10);
               RETURN;
            ELSE
               SELECT wt.serial_number
                 INTO o_sn
                 FROM sfism4.r_wip_tracking_t wt
                WHERE wt.serial_number = TRIM (i_sn);

               o_status := 'PASS';
            END IF;
         ELSE
            o_status := 'FAIL';
            o_msg :=
                  o_msg
               || 'Check MAC/SN Error, one of the two should be TRUE value'
               || CHR (13)
               || CHR (10);
            content1 := 'SET RESULT=FAIL' || CHR (13) || CHR (10);
            content1 :=
               content1 || 'SET REASON=' || o_msg || CHR (13) || CHR (10);
            RETURN;
         END IF;
      ELSE
         SELECT k.serial_number
           INTO o_sn
           FROM sfism4.r_wip_keyparts_t k, sfism4.r_part_map_t t
          WHERE     k.key_part_sn = t.compal_sn
                AND t.lan_address = i_sn
                AND ROWNUM = 1;

         o_status := 'PASS';
      END IF;
   ELSE
      SELECT k2.serial_number
        INTO o_sn
        FROM sfism4.r_wip_keyparts_t k1, sfism4.r_wip_keyparts_t k2,
             sfism4.r_part_map_t t
       WHERE     k1.key_part_sn = t.compal_sn
             AND k2.key_part_sn = k1.serial_number
             AND t.lan_address = i_sn
             AND ROWNUM = 1;

      o_status := 'PASS';
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      o_status := 'FAIL';
      o_msg := o_msg || 'Error code :' || SQLCODE || ', Message :';
      o_msg := o_msg || SUBSTR (SQLERRM, 1, 200) || CHR (13) || CHR (10);
END;


CREATE OR REPLACE PROCEDURE sfis1.c_getbom_sn_info (
   q_sn       IN     VARCHAR2,
   i_group    IN     VARCHAR2,
   o_status      OUT VARCHAR2,
   o_msg         OUT VARCHAR2,
   content1      OUT VARCHAR2)
AS
   c_count NUMBER;
   q_servtag VARCHAR2 (30);
   q_cpn VARCHAR2 (30);
   q_swidnum VARCHAR2 (30);
   q_custpn VARCHAR2 (30);
   q_model VARCHAR2 (30);
   q_region VARCHAR2 (30);
   q_molevel VARCHAR2 (30);
   q_order_type VARCHAR2 (20);
   q_mb46l VARCHAR2 (30);
   q_dbmac VARCHAR2 (30);
   q_uuid VARCHAR2 (30);
   q_db1394 VARCHAR2 (30);
   q_mbspec6 VARCHAR2 (30);
   q_vgatp VARCHAR2 (30);
   q_vgasz VARCHAR2 (30);
   q_mbtype VARCHAR2 (150);
BEGIN
   content1 := NULL;

   --Get SN Base Info
   SELECT COUNT (*)
     INTO c_count
     FROM sfism4.r_mo_base_t m, sfism4.r_wip_tracking_t w
    WHERE w.mo_number = m.mo_number AND w.serial_number = q_sn;

   IF c_count > 0
   THEN
      SELECT w.shipping_sn1, m.key_part_no, m.bto_type, m.cust_part_no,
             m.model_name, DECODE (m.dc, 'DEMEA', 'EMEA', m.dc),
             DECODE (SUBSTR (m.key_part_no, 0, 2),  '72', 'L3',  '71', 'L3',  'L10'),
             m.order_type
        INTO q_servtag, q_cpn, q_swidnum, q_custpn, q_model, q_region,
             q_molevel, q_order_type
        FROM sfism4.r_mo_base_t m, sfism4.r_wip_tracking_t w
       WHERE w.mo_number = m.mo_number AND w.serial_number = q_sn;
   END IF;

   SELECT COUNT (*)
     INTO c_count
     FROM sfism4.r_wip_tracking_t wt, sfism4.r_wip_keyparts_t w1,
          sfism4.r_wip_keyparts_t w2, sfis1.c_keyparts_desc_t d2
    WHERE     w2.key_part_no = d2.key_part_no
          AND w1.key_part_sn = w2.serial_number
          AND wt.serial_number = w2.key_part_sn
          AND wt.lan_address IS NOT NULL
          AND d2.TYPE IN ('M/B', 'MB')
          AND w1.serial_number = q_sn;

   IF c_count > 0
   THEN
      SELECT d2.key_part_no, wt.lan_address, wt.uuid, wt.ieee1394_add,
             d2.spec6, d2.spec2, d2.spec3, d2.kp_desc
        INTO q_mb46l, q_dbmac, q_uuid, q_db1394, q_mbspec6, q_vgatp, q_vgasz,
             q_mbtype
        FROM sfism4.r_wip_tracking_t wt, sfism4.r_wip_keyparts_t w1,
             sfism4.r_wip_keyparts_t w2, sfis1.c_keyparts_desc_t d2
       WHERE     w2.key_part_no = d2.key_part_no
             AND w1.key_part_sn = w2.serial_number
             AND wt.serial_number = w2.key_part_sn
             AND wt.lan_address IS NOT NULL
             AND d2.TYPE IN ('M/B', 'MB')
             AND w1.serial_number = q_sn;
   ELSE
      SELECT COUNT (*)
        INTO c_count
        FROM sfism4.r_wip_keyparts_t k, sfism4.r_wip_tracking_t p,
             sfis1.c_keyparts_desc_t d
       WHERE     k.key_part_sn = p.serial_number
             AND p.lan_address IS NOT NULL
             AND k.key_part_no = d.key_part_no
             AND d.TYPE IN ('MB', 'M/B')
             AND k.serial_number = q_sn;

      IF c_count > 0
      THEN
         SELECT k.key_part_no, p.lan_address, p.uuid, p.ieee1394_add, d.spec6,
                d.spec2, d.spec3, d.kp_desc
           INTO q_mb46l, q_dbmac, q_uuid, q_db1394, q_mbspec6, q_vgatp,
                q_vgasz, q_mbtype
           FROM sfism4.r_wip_keyparts_t k, sfism4.r_wip_tracking_t p,
                sfis1.c_keyparts_desc_t d
          WHERE     k.key_part_sn = p.serial_number
                AND p.lan_address IS NOT NULL
                AND k.key_part_no = d.key_part_no
                AND d.TYPE IN ('MB', 'M/B')
                AND k.serial_number = q_sn;
      END IF;
   END IF;

   content1 := content1 || 'SET STATION=' || i_group || CHR (13) || CHR (10);
   content1 := content1 || 'SET CUSTPN=' || q_custpn || CHR (13) || CHR (10);
   content1 := content1 || 'SET CPN=' || q_cpn || CHR (13) || CHR (10);
   content1 := content1 || 'SET ModelID=' || q_model || CHR (13) || CHR (10);
   content1 := content1 || 'SET NBID=' || q_sn || CHR (13) || CHR (10);
   content1 := content1 || 'SET SWIDNUM=' || q_swidnum || CHR (13) || CHR (10);
   content1 := content1 || 'SET SERVTAG=' || q_servtag || CHR (13) || CHR (10);
   content1 := content1 || 'SET MB46L=' || q_mb46l || CHR (13) || CHR (10);
   content1 := content1 || 'SET DBMAC=' || q_dbmac || CHR (13) || CHR (10);
   content1 := content1 || 'SET DBDDMAC=' || q_dbmac || CHR (13) || CHR (10);
   content1 := content1 || 'SET UUID=' || q_uuid || CHR (13) || CHR (10);
   content1 := content1 || 'SET DB1394=' || q_db1394 || CHR (13) || CHR (10);
   content1 := content1 || 'SET REGION=' || q_region || CHR (13) || CHR (10);
   content1 := content1 || 'SET MBTYPE=' || q_mbtype || CHR (13) || CHR (10);
   content1 :=
      content1 || 'SET ORDER_TYPE=' || q_order_type || CHR (13) || CHR (10);
--End Get SN Base Info
EXCEPTION
   WHEN OTHERS
   THEN
      o_status := 'FAIL';
      o_msg := o_msg || 'Error code :' || SQLCODE || ', Message :';
      o_msg := o_msg || SUBSTR (SQLERRM, 1, 200) || CHR (13) || CHR (10);
END;

/* Formatted on 2023/9/4 下午 04:10:50 (QP5 v5.256.13226.35538) */
CREATE OR REPLACE PROCEDURE sfis1.c_getbom_read_spec1 (q_sn       IN     VARCHAR2,
                                                       q_key1     IN     VARCHAR2,
                                                       q_spec     IN     VARCHAR2,
                                                       o_spec        OUT VARCHAR2,
                                                       o_status      OUT VARCHAR2,
                                                       o_msg         OUT VARCHAR2)
AS
   c_count NUMBER;
   m_spec1 VARCHAR2 (50);
   m_spec2 VARCHAR2 (50);
   m_spec3 VARCHAR2 (50);
   m_spec4 VARCHAR2 (50);
   m_spec5 VARCHAR2 (50);
   m_spec6 VARCHAR2 (50);
   m_spec7 VARCHAR2 (50);
   m_spec8 VARCHAR2 (50);
   m_spec9 VARCHAR2 (50);
   m_spec10 VARCHAR2 (50);
   m_kp_desc VARCHAR2 (50);
BEGIN
   SELECT COUNT (*)
     INTO c_count
     FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
    WHERE a.key_part_no = b.key_part_no AND b.TYPE = q_key1 AND a.serial_number = q_sn;

   IF c_count > 0
   THEN
      SELECT b.spec1, b.spec2, b.spec3, b.spec4, b.spec5, b.spec6, b.spec7, b.spec8, b.spec9, b.spec10, b.kp_desc
        INTO m_spec1, m_spec2, m_spec3, m_spec4, m_spec5, m_spec6, m_spec7, m_spec8, m_spec9, m_spec10, m_kp_desc
        FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
       WHERE a.key_part_no = b.key_part_no AND b.TYPE = q_key1 AND a.serial_number = q_sn AND ROWNUM = 1;

      CASE
         WHEN q_spec = 'SPEC1'
         THEN
            o_spec := m_spec1;
         WHEN q_spec = 'SPEC2'
         THEN
            o_spec := m_spec2;
         WHEN q_spec = 'SPEC3'
         THEN
            o_spec := m_spec3;
         WHEN q_spec = 'SPEC4'
         THEN
            o_spec := m_spec4;
         WHEN q_spec = 'SPEC5'
         THEN
            o_spec := m_spec5;
         WHEN q_spec = 'SPEC6'
         THEN
            o_spec := m_spec6;
         WHEN q_spec = 'SPEC7'
         THEN
            o_spec := m_spec7;
         WHEN q_spec = 'SPEC8'
         THEN
            o_spec := m_spec8;
         WHEN q_spec = 'SPEC9'
         THEN
            o_spec := m_spec9;
         WHEN q_spec = 'SPEC10'
         THEN
            o_spec := m_spec10;
         WHEN q_spec = 'KP_DESC'
         THEN
            o_spec := m_kp_desc;
         ELSE
            o_spec := NULL;
      END CASE;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      o_status := 'FAIL';
      o_msg := o_msg || 'Error code :' || SQLCODE || ', Message :';
      o_msg := o_msg || SUBSTR (SQLERRM, 1, 200) || CHR (13) || CHR (10);
END;



CREATE OR REPLACE PROCEDURE sfis1.c_getbom_read_spec2 (q_sn       IN     VARCHAR2,
                                                       q_key1     IN     VARCHAR2,
                                                       q_key2     IN     VARCHAR2,
                                                       q_spec     IN     VARCHAR2,
                                                       o_spec        OUT VARCHAR2,
                                                       o_status      OUT VARCHAR2,
                                                       o_msg         OUT VARCHAR2)
AS
   c_count NUMBER;
   m_spec1 VARCHAR2 (50);
   m_spec2 VARCHAR2 (50);
   m_spec3 VARCHAR2 (50);
   m_spec4 VARCHAR2 (50);
   m_spec5 VARCHAR2 (50);
   m_spec6 VARCHAR2 (50);
   m_spec7 VARCHAR2 (50);
   m_spec8 VARCHAR2 (50);
   m_spec9 VARCHAR2 (50);
   m_spec10 VARCHAR2 (50);
   m_kp_desc VARCHAR2 (50);
BEGIN
   IF q_key2 IS NULL
   THEN
      SELECT COUNT (*)
        INTO c_count
        FROM sfism4.r_wip_keyparts_t k1, sfism4.r_wip_keyparts_t k2, sfis1.c_keyparts_desc_t d1,
             sfis1.c_keyparts_desc_t d2
       WHERE     k2.serial_number = k1.key_part_sn
             AND d1.key_part_no = k1.key_part_no
             AND d2.key_part_no = k2.key_part_no
             AND d2.TYPE = q_key1
             AND k1.serial_number = q_sn;

      IF c_count > 0
      THEN
         SELECT d2.spec1, d2.spec2, d2.spec3, d2.spec4, d2.spec5, d2.spec6, d2.spec7, d2.spec8, d2.spec9, d2.spec10,
                d2.kp_desc
           INTO m_spec1, m_spec2, m_spec3, m_spec4, m_spec5, m_spec6, m_spec7, m_spec8, m_spec9, m_spec10, m_kp_desc
           FROM sfism4.r_wip_keyparts_t k1, sfism4.r_wip_keyparts_t k2, sfis1.c_keyparts_desc_t d1,
                sfis1.c_keyparts_desc_t d2
          WHERE     k2.serial_number = k1.key_part_sn
                AND d1.key_part_no = k1.key_part_no
                AND d2.key_part_no = k2.key_part_no
                AND d2.TYPE = q_key1
                AND k1.serial_number = q_sn
                AND ROWNUM = 1;
      END IF;
   ELSE
      SELECT COUNT (*)
        INTO c_count
        FROM sfism4.r_wip_keyparts_t k1, sfism4.r_wip_keyparts_t k2, sfis1.c_keyparts_desc_t d1,
             sfis1.c_keyparts_desc_t d2
       WHERE     k2.serial_number = k1.key_part_sn
             AND d1.key_part_no = k1.key_part_no
             AND d2.key_part_no = k2.key_part_no
             AND d1.TYPE = q_key1
             AND d2.TYPE = q_key2
             AND k1.serial_number = q_sn;

      IF c_count > 0
      THEN
         SELECT d2.spec1, d2.spec2, d2.spec3, d2.spec4, d2.spec5, d2.spec6, d2.spec7, d2.spec8, d2.spec9, d2.spec10
           INTO m_spec1, m_spec2, m_spec3, m_spec4, m_spec5, m_spec6, m_spec7, m_spec8, m_spec9, m_spec10
           FROM sfism4.r_wip_keyparts_t k1, sfism4.r_wip_keyparts_t k2, sfis1.c_keyparts_desc_t d1,
                sfis1.c_keyparts_desc_t d2
          WHERE     k2.serial_number = k1.key_part_sn
                AND d1.key_part_no = k1.key_part_no
                AND d2.key_part_no = k2.key_part_no
                AND d1.TYPE = q_key1
                AND d2.TYPE = q_key2
                AND k1.serial_number = q_sn
                AND ROWNUM = 1;
      END IF;

      CASE
         WHEN q_spec = 'SPEC1'
         THEN
            o_spec := m_spec1;
         WHEN q_spec = 'SPEC2'
         THEN
            o_spec := m_spec2;
         WHEN q_spec = 'SPEC3'
         THEN
            o_spec := m_spec3;
         WHEN q_spec = 'SPEC4'
         THEN
            o_spec := m_spec4;
         WHEN q_spec = 'SPEC5'
         THEN
            o_spec := m_spec5;
         WHEN q_spec = 'SPEC6'
         THEN
            o_spec := m_spec6;
         WHEN q_spec = 'SPEC7'
         THEN
            o_spec := m_spec7;
         WHEN q_spec = 'SPEC8'
         THEN
            o_spec := m_spec8;
         WHEN q_spec = 'SPEC9'
         THEN
            o_spec := m_spec9;
         WHEN q_spec = 'SPEC10'
         THEN
            o_spec := m_spec10;
         WHEN q_spec = 'KP_DESC'
         THEN
            o_spec := m_kp_desc;
         ELSE
            o_spec := NULL;
      END CASE;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      o_status := 'FAIL';
      o_msg := o_msg || 'Error code :' || SQLCODE || ', Message :';
      o_msg := o_msg || SUBSTR (SQLERRM, 1, 200) || CHR (13) || CHR (10);
END;
/

CREATE OR REPLACE PROCEDURE sfis1.c_getbom_read_spec1in (q_sn       IN     VARCHAR2,
                                                         q_key1     IN     VARCHAR2,
                                                         q_key2     IN     VARCHAR2,
                                                         q_spec     IN     VARCHAR2,
                                                         o_spec        OUT VARCHAR2,
                                                         o_status      OUT VARCHAR2,
                                                         o_msg         OUT VARCHAR2)
AS
   c_count NUMBER;
   m_spec1 VARCHAR2 (50);
   m_spec2 VARCHAR2 (50);
   m_spec3 VARCHAR2 (50);
   m_spec4 VARCHAR2 (50);
   m_spec5 VARCHAR2 (50);
   m_spec6 VARCHAR2 (50);
   m_spec7 VARCHAR2 (50);
   m_spec8 VARCHAR2 (50);
   m_spec9 VARCHAR2 (50);
   m_spec10 VARCHAR2 (50);
   m_kp_desc VARCHAR2 (50);
BEGIN
   SELECT COUNT (*)
     INTO c_count
     FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
    WHERE a.key_part_no = b.key_part_no AND b.TYPE IN (q_key1, q_key2) AND a.serial_number = q_sn;

   IF c_count > 0
   THEN
      SELECT b.spec1, b.spec2, b.spec3, b.spec4, b.spec5, b.spec6, b.spec7, b.spec8, b.spec9, b.spec10, b.kp_desc
        INTO m_spec1, m_spec2, m_spec3, m_spec4, m_spec5, m_spec6, m_spec7, m_spec8, m_spec9, m_spec10, m_kp_desc
        FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
       WHERE a.key_part_no = b.key_part_no AND b.TYPE IN (q_key1, q_key2) AND a.serial_number = q_sn AND ROWNUM = 1;

      CASE
         WHEN q_spec = 'SPEC1'
         THEN
            o_spec := m_spec1;
         WHEN q_spec = 'SPEC2'
         THEN
            o_spec := m_spec2;
         WHEN q_spec = 'SPEC3'
         THEN
            o_spec := m_spec3;
         WHEN q_spec = 'SPEC4'
         THEN
            o_spec := m_spec4;
         WHEN q_spec = 'SPEC5'
         THEN
            o_spec := m_spec5;
         WHEN q_spec = 'SPEC6'
         THEN
            o_spec := m_spec6;
         WHEN q_spec = 'SPEC7'
         THEN
            o_spec := m_spec7;
         WHEN q_spec = 'SPEC8'
         THEN
            o_spec := m_spec8;
         WHEN q_spec = 'SPEC9'
         THEN
            o_spec := m_spec9;
         WHEN q_spec = 'SPEC10'
         THEN
            o_spec := m_spec10;
         WHEN q_spec = 'KP_DESC'
         THEN
            o_spec := m_kp_desc;
         ELSE
            o_spec := NULL;
      END CASE;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      o_status := 'FAIL';
      o_msg := o_msg || 'Error code :' || SQLCODE || ', Message :' || SUBSTR (SQLERRM, 1, 200) || CHR (13) || CHR (10);
END;

CREATE OR REPLACE PROCEDURE sfis1.c_getbom_read_spec2in (q_sn       IN     VARCHAR2,
                                                         q_key1     IN     VARCHAR2,
                                                         q_key2     IN     VARCHAR2,
                                                         q_spec     IN     VARCHAR2,
                                                         o_spec        OUT VARCHAR2,
                                                         o_status      OUT VARCHAR2,
                                                         o_msg         OUT VARCHAR2)
AS
   c_count NUMBER;
   m_spec1 VARCHAR2 (50);
   m_spec2 VARCHAR2 (50);
   m_spec3 VARCHAR2 (50);
   m_spec4 VARCHAR2 (50);
   m_spec5 VARCHAR2 (50);
   m_spec6 VARCHAR2 (50);
   m_spec7 VARCHAR2 (50);
   m_spec8 VARCHAR2 (50);
   m_spec9 VARCHAR2 (50);
   m_spec10 VARCHAR2 (50);
   m_kp_desc VARCHAR2 (50);
BEGIN
   IF q_key2 IS NULL
   THEN
      SELECT COUNT (*)
        INTO c_count
        FROM sfism4.r_wip_keyparts_t b, sfis1.c_keyparts_desc_t a, sfism4.r_wip_keyparts_t c
       WHERE     b.serial_number = c.key_part_sn
             AND a.key_part_no = b.key_part_no
             AND a.TYPE IN (q_key1)
             AND c.serial_number = q_sn
             AND ROWNUM = 1;

      IF c_count > 0
      THEN
         SELECT a.spec1, a.spec2, a.spec3, a.spec4, a.spec5, a.spec6, a.spec7, a.spec8, a.spec9, a.spec10, a.kp_desc
           INTO m_spec1, m_spec2, m_spec3, m_spec4, m_spec5, m_spec6, m_spec7, m_spec8, m_spec9, m_spec10, m_kp_desc
           FROM sfism4.r_wip_keyparts_t b, sfis1.c_keyparts_desc_t a, sfism4.r_wip_keyparts_t c
          WHERE     b.serial_number = c.key_part_sn
                AND a.key_part_no = b.key_part_no
                AND a.TYPE IN (q_key1)
                AND c.serial_number = q_sn
                AND ROWNUM = 1;
      END IF;
   ELSE
      SELECT COUNT (*)
        INTO c_count
        FROM sfism4.r_wip_keyparts_t b, sfis1.c_keyparts_desc_t a, sfism4.r_wip_keyparts_t c
       WHERE     b.serial_number = c.key_part_sn
             AND a.key_part_no = b.key_part_no
             AND a.TYPE IN (q_key1, q_key2)
             AND c.serial_number = q_sn
             AND ROWNUM = 1;

      IF c_count > 0
      THEN
         SELECT a.spec1, a.spec2, a.spec3, a.spec4, a.spec5, a.spec6, a.spec7, a.spec8, a.spec9, a.spec10, a.kp_desc
           INTO m_spec1, m_spec2, m_spec3, m_spec4, m_spec5, m_spec6, m_spec7, m_spec8, m_spec9, m_spec10, m_kp_desc
           FROM sfism4.r_wip_keyparts_t b, sfis1.c_keyparts_desc_t a, sfism4.r_wip_keyparts_t c
          WHERE     b.serial_number = c.key_part_sn
                AND a.key_part_no = b.key_part_no
                AND a.TYPE IN (q_key1, q_key2)
                AND c.serial_number = q_sn
                AND ROWNUM = 1;
      END IF;
   END IF;

   CASE
      WHEN q_spec = 'SPEC1'
      THEN
         o_spec := m_spec1;
      WHEN q_spec = 'SPEC2'
      THEN
         o_spec := m_spec2;
      WHEN q_spec = 'SPEC3'
      THEN
         o_spec := m_spec3;
      WHEN q_spec = 'SPEC4'
      THEN
         o_spec := m_spec4;
      WHEN q_spec = 'SPEC5'
      THEN
         o_spec := m_spec5;
      WHEN q_spec = 'SPEC6'
      THEN
         o_spec := m_spec6;
      WHEN q_spec = 'SPEC7'
      THEN
         o_spec := m_spec7;
      WHEN q_spec = 'SPEC8'
      THEN
         o_spec := m_spec8;
      WHEN q_spec = 'SPEC9'
      THEN
         o_spec := m_spec9;
      WHEN q_spec = 'SPEC10'
      THEN
         o_spec := m_spec10;
      WHEN q_spec = 'KP_DESC'
      THEN
         o_spec := m_kp_desc;
      ELSE
         o_spec := NULL;
   END CASE;
EXCEPTION
   WHEN OTHERS
   THEN
      o_status := 'FAIL';
      o_msg := o_msg || 'Error code :' || SQLCODE || ', Message :';
      o_msg := o_msg || SUBSTR (SQLERRM, 1, 200) || CHR (13) || CHR (10);
END;

CREATE OR REPLACE PROCEDURE sfis1.c_getbom_secondmac (
   q_sn       IN     VARCHAR2,
   o_status      OUT VARCHAR2,
   o_msg         OUT VARCHAR2,
   content1      OUT VARCHAR2)
AS
   c_count NUMBER;
   q_secondmac VARCHAR2 (100);
BEGIN
   content1 := NULL;

   --Get SECONDMAC Info    Aaronl_Lin Add @2023/04/06
   SELECT COUNT (*)
     INTO c_count
     FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
    WHERE     a.key_part_no = b.key_part_no
          AND b.TYPE IN ('CARRIER/B', 'INT/B')
          AND a.serial_number = q_sn;

   IF c_count > 0
   THEN
      SELECT m.lan_address
        INTO q_secondmac
        FROM sfism4.r_part_map_t m, sfism4.r_wip_keyparts_t k,
             sfis1.c_keyparts_desc_t d
       WHERE     m.compal_sn = k.key_part_sn
             AND k.serial_number = q_sn
             AND m.lan_address IS NOT NULL
             AND k.key_part_sn <> 'N/A'
             AND k.key_part_sn IS NOT NULL
             AND k.key_part_no = d.key_part_no
             AND d.TYPE IN ('CARRIER/B', 'INT/B')
             AND ROWNUM = 1;

      content1 :=
         content1 || 'SET SECONDMAC=' || q_secondmac || CHR (13) || CHR (10);
   ELSE
      content1 := content1 || 'SET SECONDMAC=EMPTY' || CHR (13) || CHR (10);
   END IF;
--Get SECONDMAC Info
EXCEPTION
   WHEN OTHERS
   THEN
      o_status := 'FAIL';
      o_msg := o_msg || 'Error code :' || SQLCODE || ', Message :';
      o_msg := o_msg || SUBSTR (SQLERRM, 1, 200) || CHR (13) || CHR (10);
END;

CREATE OR REPLACE PROCEDURE sfis1.c_getbom_fprint (
   q_sn       IN     VARCHAR2,
   o_status      OUT VARCHAR2,
   o_msg         OUT VARCHAR2,
   content1      OUT VARCHAR2)
AS
   c_count NUMBER;
   q_fprint VARCHAR2 (30);
   q_molevel VARCHAR2 (30);
BEGIN
   content1 := NULL;

   --GET FPRINT INFO
   sfis1.c_getbom_read_spec1 (q_sn, 'FPRINT', 'SPEC1', q_fprint, o_status, o_msg);

   IF (q_fprint IS NULL)
   THEN
      sfis1.c_getbom_read_spec2 (q_sn, 'FPR', 'FPRINT', 'SPEC1', q_fprint, o_status, o_msg);

      IF (q_fprint IS NULL)
      THEN
         sfis1.c_getbom_read_spec2 (q_sn, 'PWR/B', 'FPRINT', 'SPEC1', q_fprint, o_status, o_msg);
      END IF;

      SELECT DECODE (SUBSTR (m.key_part_no, 0, 2),  '72', 'L3',  '71', 'L3',  'L10')
        INTO q_molevel
        FROM sfism4.r_mo_base_t m, sfism4.r_wip_tracking_t w
       WHERE w.mo_number = m.mo_number AND w.serial_number = q_sn;

      IF (q_molevel = 'L10' OR q_molevel = 'L3') AND (q_fprint IS NULL)
      THEN
         sfis1.c_getbom_read_spec1 (q_sn, 'UPPER', 'SPEC1', q_fprint, o_status, o_msg);
      END IF;

      IF (q_fprint IS NULL)
      THEN
         sfis1.c_getbom_read_spec2 (q_sn, 'BASE', 'UPPER', 'SPEC1', q_fprint, o_status, o_msg);
      END IF;

      IF (q_fprint IS NULL)
      THEN
         sfis1.c_getbom_read_spec1 (q_sn, 'KB TRIM', 'SPEC1', q_fprint, o_status, o_msg);
      END IF;

      IF (q_fprint IS NULL)
      THEN
         sfis1.c_getbom_read_spec2 (q_sn, 'UPPER', 'FPRINT', 'SPEC1', q_fprint, o_status, o_msg);
      END IF;

      IF (q_fprint IS NULL)
      THEN
         sfis1.c_getbom_read_spec2 (q_sn, 'BASE', 'FPRINT', 'SPEC1', q_fprint, o_status, o_msg);
      END IF;

      IF (q_fprint IS NULL)
      THEN
         sfis1.c_getbom_read_spec2 (q_sn, 'UPPER', 'UPPER', 'SPEC1', q_fprint, o_status, o_msg);
      END IF;

      IF (q_fprint IS NULL)
      THEN
         sfis1.c_getbom_read_spec2 (q_sn, 'COVER', 'FPRINT', 'SPEC1', q_fprint, o_status, o_msg);
      END IF;

      IF (q_fprint IS NULL)
      THEN
         SELECT COUNT (*)
           INTO c_count
           FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
          WHERE     a.key_part_no = b.key_part_no
                AND b.TYPE LIKE 'FP%'
                AND a.serial_number = q_sn;

         IF c_count > 0
         THEN
            q_fprint := 'EXIST';
         ELSE
            q_fprint := 'EMPTY';
         END IF;
      END IF;
   END IF;

   content1 := content1 || 'SET FPRINT=' || q_fprint || CHR (13) || CHR (10);
-- END GET FPRINT INFO
EXCEPTION
   WHEN OTHERS
   THEN
      o_status := 'FAIL';
      o_msg := o_msg || 'Error code :' || SQLCODE || ', Message :';
      o_msg := o_msg || SUBSTR (SQLERRM, 1, 200) || CHR (13) || CHR (10);
END;

CREATE OR REPLACE PROCEDURE sfis1.c_getbom_smart_card (
   q_sn       IN     VARCHAR2,
   o_status      OUT VARCHAR2,
   o_msg         OUT VARCHAR2,
   content1      OUT VARCHAR2)
AS
   c_count NUMBER;
   q_smart VARCHAR2 (30);
   q_molevel VARCHAR2 (30);
BEGIN
   content1 := NULL;
   --GET SMART_CARD INFO
   sfis1.c_getbom_read_spec1 (q_sn, 'SMART CARD', 'SPEC2', q_smart, o_status, o_msg);

   SELECT DECODE (SUBSTR (m.key_part_no, 0, 2),  '72', 'L3',  '71', 'L3',  'L10')
     INTO q_molevel
     FROM sfism4.r_mo_base_t m, sfism4.r_wip_tracking_t w
    WHERE w.mo_number = m.mo_number AND w.serial_number = q_sn;

   IF (q_smart IS NULL AND q_molevel = 'L10')
   THEN
      sfis1.c_getbom_read_spec1 (q_sn, 'EXPRESS CARD', 'SPEC3', q_smart, o_status, o_msg);
   END IF;

   IF q_smart IS NULL
   THEN
      sfis1.c_getbom_read_spec1 (q_sn, 'UPPER', 'SPEC2', q_smart, o_status, o_msg);
   END IF;

   IF q_smart IS NULL OR q_smart = 'EMPTY'
   THEN
      sfis1.c_getbom_read_spec2 (q_sn, 'UPPER', 'SMART CARD', 'SPEC2', q_smart, o_status, o_msg);
   END IF;

   IF q_smart IS NULL OR q_smart = 'EMPTY'
   THEN
      sfis1.c_getbom_read_spec2 (q_sn, 'BASE', 'SMART CARD', 'SPEC2', q_smart, o_status, o_msg);
   END IF;

   IF q_smart IS NULL OR q_smart = 'EMPTY'
   THEN
      sfis1.c_getbom_read_spec2 (q_sn, 'BASE', 'UPPER', 'SPEC2', q_smart, o_status, o_msg);
   END IF;

   IF q_smart IS NULL OR q_smart = 'EMPTY'
   THEN
      sfis1.c_getbom_read_spec2 (q_sn, 'LOG UP', 'SMART CARD', 'SPEC2', q_smart, o_status, o_msg);
   END IF;

   IF q_smart IS NULL OR q_smart = 'EMPTY'
   THEN
      sfis1.c_getbom_read_spec2 (q_sn, 'COVER', 'SMART CARD', 'SPEC2', q_smart, o_status, o_msg);
   END IF;

   IF q_smart IS NULL
   THEN
      q_smart := 'EMPTY';
   END IF;

   content1 :=
      content1 || 'SET SMART_CARD=' || q_smart || CHR (13) || CHR (10);
--END GET SMART_CARD INFO
EXCEPTION
   WHEN OTHERS
   THEN
      o_status := 'FAIL';
      o_msg := o_msg || 'Error code :' || SQLCODE || ', Message :';
      o_msg := o_msg || SUBSTR (SQLERRM, 1, 200) || CHR (13) || CHR (10);
END;

CREATE OR REPLACE PROCEDURE sfis1.c_getbom_mbsnswdl (
   q_sn       IN     VARCHAR2,
   o_status      OUT VARCHAR2,
   o_msg         OUT VARCHAR2,
   content1      OUT VARCHAR2)
AS
   c_count NUMBER;
   q_mbsn VARCHAR2 (30);
   q_mbbtmac VARCHAR2 (30);
   q_mbwlanmac VARCHAR2 (30);
BEGIN
   content1 := NULL;

   --GET MBSNSWDL INFO 20230415 Aaronl_lin
   SELECT COUNT (*)
     INTO c_count
     FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
    WHERE     a.key_part_no = b.key_part_no
          AND b.TYPE IN ('MB')
          AND a.serial_number = q_sn;

   IF c_count > 0
   THEN
      SELECT a.key_part_sn
        INTO q_mbsn
        FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
       WHERE     a.key_part_no = b.key_part_no
             AND b.TYPE IN ('MB')
             AND a.serial_number = q_sn
             AND ROWNUM = 1;
   ELSE
      SELECT COUNT (*)
        INTO c_count
        FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
       WHERE     a.key_part_no = b.key_part_no
             AND b.TYPE IN ('M/B')
             AND a.serial_number = q_sn;

      IF c_count > 0
      THEN
         SELECT a.key_part_sn
           INTO q_mbsn
           FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
          WHERE     a.key_part_no = b.key_part_no
                AND b.TYPE IN ('M/B')
                AND a.serial_number = q_sn
                AND ROWNUM = 1;
      ELSE
         SELECT COUNT (*)
           INTO c_count
           FROM sfism4.r_wip_keyparts_t wk, sfism4.r_wip_keyparts_t kk,
                sfis1.c_keyparts_desc_t kd
          WHERE     wk.key_part_sn = kk.serial_number
                AND kk.key_part_no = kd.key_part_no
                AND kd.TYPE IN ('MB', 'M/B')
                AND LENGTH (wk.key_part_sn) = 13
                AND wk.serial_number = q_sn;

         IF c_count > 0
         THEN
            SELECT kk.key_part_sn
              INTO q_mbsn
              FROM sfism4.r_wip_keyparts_t wk, sfism4.r_wip_keyparts_t kk,
                   sfis1.c_keyparts_desc_t kd
             WHERE     wk.key_part_sn = kk.serial_number
                   AND kk.key_part_no = kd.key_part_no
                   AND kd.TYPE IN ('MB', 'M/B')
                   AND LENGTH (wk.key_part_sn) = 13
                   AND wk.serial_number = q_sn
                   AND ROWNUM = 1;
         END IF;
      END IF;
   END IF;

   IF q_mbsn IS NOT NULL
   THEN
      SELECT COUNT (a.mac)
        INTO c_count
        FROM sfism4.r_swdl_t a
       WHERE a.serial_number = q_mbsn;

      IF c_count > 0
      THEN
         SELECT a.mac
           INTO q_mbbtmac
           FROM sfism4.r_swdl_t a
          WHERE a.serial_number = q_mbsn AND ROWNUM = 1;
      ELSE
         SELECT COUNT (t.mac_addr)
           INTO c_count
           FROM sfism4.r_wip_macaddr_t t
          WHERE t.wip_sn = q_mbsn AND t.mac_type = 'RJ45EXT';

         IF c_count > 0
         THEN
            SELECT t.mac_addr
              INTO q_mbbtmac
              FROM sfism4.r_wip_macaddr_t t
             WHERE     t.wip_sn = q_mbsn
                   AND t.mac_type = 'RJ45EXT'
                   AND ROWNUM = 1;
         END IF;
      END IF;

      SELECT COUNT (a.wifimac)
        INTO c_count
        FROM sfism4.r_swdl_t a
       WHERE a.serial_number = q_mbsn;

      IF c_count > 0
      THEN
         SELECT a.wifimac
           INTO q_mbwlanmac
           FROM sfism4.r_swdl_t a
          WHERE a.serial_number = q_mbsn AND ROWNUM = 1;
      ELSE
         SELECT COUNT (t.mac_addr)
           INTO c_count
           FROM sfism4.r_wip_macaddr_t t
          WHERE t.wip_sn = q_mbsn AND t.mac_type = 'WIRELESS';

         IF c_count > 0
         THEN
            SELECT t.mac_addr
              INTO q_mbwlanmac
              FROM sfism4.r_wip_macaddr_t t
             WHERE     t.wip_sn = q_mbsn
                   AND t.mac_type = 'WIRELESS'
                   AND ROWNUM = 1;
         END IF;
      END IF;

      IF q_mbbtmac IS NOT NULL
      THEN
         content1 :=
            content1 || 'SET BTMAC=' || q_mbbtmac || CHR (13) || CHR (10);
      ELSE
         content1 := content1 || 'SET BTMAC=EMPTY' || CHR (13) || CHR (10);
      END IF;

      IF q_mbwlanmac IS NOT NULL
      THEN
         content1 :=
            content1 || 'SET PWLMAC=' || q_mbwlanmac || CHR (13) || CHR (10);
      ELSE
         content1 := content1 || 'SET PWLMAC=EMPTY' || CHR (13) || CHR (10);
      END IF;
   ELSE
      content1 := content1 || 'SET BTMAC=EMPTY' || CHR (13) || CHR (10);
      content1 := content1 || 'SET PWLMAC=EMPTY' || CHR (13) || CHR (10);
   END IF;
--END GET MBSNSWDL INFO

EXCEPTION
   WHEN OTHERS
   THEN
      o_status := 'FAIL';
      o_msg := o_msg || 'Error code :' || SQLCODE || ', Message :';
      o_msg := o_msg || SUBSTR (SQLERRM, 1, 200) || CHR (13) || CHR (10);
END;

CREATE OR REPLACE PROCEDURE sfis1.c_getbom_rfid (q_sn       IN     VARCHAR2,
                                                 o_status      OUT VARCHAR2,
                                                 o_msg         OUT VARCHAR2,
                                                 content1      OUT VARCHAR2)
AS
   c_count NUMBER;
   q_rfid VARCHAR2 (30);
   q_molevel VARCHAR2 (30);
BEGIN
   content1 := NULL;
   --GET RFID INFO

   sfis1.c_getbom_read_spec1 (
   q_sn, 'UPPER', 'SPEC4', q_rfid, o_status, o_msg);

   IF q_rfid IS NULL
   THEN
      sfis1.c_getbom_read_spec1 (q_sn, 'SMART CARD', 'SPEC2', q_rfid, o_status, o_msg);
   END IF;

   SELECT DECODE (SUBSTR (m.key_part_no, 0, 2),  '72', 'L3',  '71', 'L3',  'L10')
     INTO q_molevel
     FROM sfism4.r_mo_base_t m, sfism4.r_wip_tracking_t w
    WHERE w.mo_number = m.mo_number AND w.serial_number = q_sn;

   IF q_molevel = 'L10'
   THEN
      --Yann Add 2017/12/11
      IF q_rfid IS NULL
      THEN
         sfis1.c_getbom_read_spec1 (q_sn, 'KB TRIM', 'SPEC4', q_rfid, o_status, o_msg);
      END IF;

      IF q_rfid IS NULL
      THEN
         sfis1.c_getbom_read_spec2 (q_sn, 'BASE', 'UPPER', 'SPEC4', q_rfid, o_status, o_msg);
      END IF;

      IF q_rfid IS NULL
      THEN
         sfis1.c_getbom_read_spec2 (q_sn, 'UPPER', 'UPPER', 'SPEC4', q_rfid, o_status, o_msg);
      END IF;
   END IF;

   IF q_rfid IS NULL
   THEN
      q_rfid := 'EMPTY';
   END IF;

   content1 := content1 || 'SET RFID=' || q_rfid || CHR (13) || CHR (10); --END GET RFID INFO
EXCEPTION
   WHEN OTHERS
   THEN
      o_status := 'FAIL';
      o_msg := o_msg || 'Error code :' || SQLCODE || ', Message :';
      o_msg := o_msg || SUBSTR (SQLERRM, 1, 200) || CHR (13) || CHR (10);
END;

/* Formatted on 2023/9/4 上午 10:36:16 (QP5 v5.256.13226.35538) */
CREATE OR REPLACE PROCEDURE sfis1.c_getbom_cover_color (
   q_sn       IN     VARCHAR2,
   o_status      OUT VARCHAR2,
   o_msg         OUT VARCHAR2,
   content1      OUT VARCHAR2)
AS
   c_count NUMBER;
   q_color VARCHAR2 (30);
BEGIN
   content1 := NULL;

   --GET COVER COLOR INFO
   SELECT COUNT (*)
     INTO c_count
     FROM sfism4.r_wip_keyparts_t a, sfis1.c_part_control_t b
    WHERE     a.key_part_no = b.key_part_no
          AND b.part_type = 'COVER_COLOR'
          AND b.vender_part_no = 'SWDL'
          AND a.serial_number = q_sn;

   IF c_count > 0
   THEN
      SELECT b.cust_part_no
        INTO q_color
        FROM sfism4.r_wip_keyparts_t a, sfis1.c_part_control_t b
       WHERE     a.key_part_no = b.key_part_no
             AND b.part_type = 'COVER_COLOR'
             AND b.vender_part_no = 'SWDL'
             AND a.serial_number = q_sn
             AND ROWNUM = 1;

      content1 :=
         content1 || 'SET COVER_COLOR=' || q_color || CHR (13) || CHR (10);
   ELSE
      content1 := content1 || 'SET COVER_COLOR=EMPTY' || CHR (13) || CHR (10);
   END IF;
--END GET COVER COLOR INFO
EXCEPTION
   WHEN OTHERS
   THEN
      o_status := 'FAIL';
      o_msg := o_msg || 'Error code :' || SQLCODE || ', Message :';
      o_msg := o_msg || SUBSTR (SQLERRM, 1, 200) || CHR (13) || CHR (10);
END;

CREATE OR REPLACE PROCEDURE sfis1.c_getbom_sp_button (
   q_sn       IN     VARCHAR2,
   o_status      OUT VARCHAR2,
   o_msg         OUT VARCHAR2,
   content1      OUT VARCHAR2)
AS
   c_count NUMBER;
   q_button VARCHAR2 (30);
BEGIN
   content1 := NULL;

   --GET NFC/SP_BUTTON INFO 20230413 Aaronl_lin
   SELECT COUNT (b.spec5)
     INTO c_count
     FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
    WHERE     a.key_part_no = b.key_part_no
          AND b.TYPE = 'UPPER'
          AND LENGTH (a.key_part_sn) <> 13
          AND a.serial_number = q_sn;

   IF c_count > 0
   THEN
      SELECT b.spec5 --, B.SPEC6
        INTO q_button --, Q_NFC
        FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
       WHERE     a.key_part_no = b.key_part_no
             AND b.TYPE = 'UPPER'
             AND LENGTH (a.key_part_sn) <> 13
             AND a.serial_number = q_sn
             AND ROWNUM = 1;
   ELSE
      SELECT COUNT (b.spec5)
        INTO c_count
        FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b,
             sfism4.r_wip_keyparts_t c
       WHERE     a.key_part_sn = c.serial_number
             AND c.key_part_no = b.key_part_no
             AND b.TYPE = 'UPPER'
             AND LENGTH (a.key_part_sn) = 13
             AND a.serial_number = q_sn;

      IF c_count > 0
      THEN
         SELECT b.spec5
           INTO q_button
           FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b,
                sfism4.r_wip_keyparts_t c
          WHERE     a.key_part_sn = c.serial_number
                AND c.key_part_no = b.key_part_no
                AND b.TYPE = 'UPPER'
                AND LENGTH (a.key_part_sn) = 13
                AND a.serial_number = q_sn;
      ELSE
         sfis1.c_getbom_read_spec1 (q_sn, 'UPPER', 'SPEC5', q_button, o_status, o_msg);
      END IF;
   END IF;

   IF q_button IS NULL
   THEN
      q_button := 'EMPTY';
   END IF;

   content1 :=
      content1 || 'SET SP_BUTTON=' || q_button || CHR (13) || CHR (10);
--END GET NFC/SP_BUTTON INFO
EXCEPTION
   WHEN OTHERS
   THEN
      o_status := 'FAIL';
      o_msg := o_msg || 'Error code :' || SQLCODE || ', Message :';
      o_msg := o_msg || SUBSTR (SQLERRM, 1, 200) || CHR (13) || CHR (10);
END;


CREATE OR REPLACE PROCEDURE sfis1.c_getbom_nfc (q_sn       IN     VARCHAR2,
                                                o_status      OUT VARCHAR2,
                                                o_msg         OUT VARCHAR2,
                                                content1      OUT VARCHAR2)
AS
   c_count NUMBER;
   q_nfc VARCHAR2 (30);
BEGIN
   content1 := NULL;
   --GET NFC INFO
   sfis1.c_getbom_read_spec1 (q_sn, 'UPPER', 'SPEC6', q_nfc, o_status, o_msg);

   IF q_nfc IS NULL
   THEN
      sfis1.c_getbom_read_spec2 (q_sn, 'UPPER', NULL, 'SPEC6', q_nfc, o_status, o_msg);
   END IF;

   IF q_nfc IS NULL
   THEN
      sfis1.c_getbom_read_spec1 (q_sn, 'BASE', 'SPEC6', q_nfc, o_status, o_msg);
   END IF;

   IF q_nfc IS NULL
   THEN
      sfis1.c_getbom_read_spec2 (q_sn, 'BASE', 'NFC', 'SPEC6', q_nfc, o_status, o_msg);
   END IF;

   IF q_nfc IS NULL
   THEN
      sfis1.c_getbom_read_spec2 (q_sn, 'UPPER', 'NFC', 'SPEC6', q_nfc, o_status, o_msg);
   END IF;

   IF q_nfc IS NULL
   THEN
      sfis1.c_getbom_read_spec2 (q_sn, 'COVER', 'NFC', 'SPEC6', q_nfc, o_status, o_msg);
   END IF;

   IF q_nfc IS NULL
   THEN
      content1 := content1 || 'SET NFC=EMPTY' || CHR (13) || CHR (10);
   ELSE
      content1 := content1 || 'SET NFC=' || q_nfc || CHR (13) || CHR (10);
   END IF;
--END GET NFC INFO
EXCEPTION
   WHEN OTHERS
   THEN
      o_status := 'FAIL';
      o_msg := o_msg || 'Error code :' || SQLCODE || ', Message :';
      o_msg := o_msg || SUBSTR (SQLERRM, 1, 200) || CHR (13) || CHR (10);
END;

CREATE OR REPLACE PROCEDURE sfis1.c_getbom_camera (
   q_sn       IN     VARCHAR2,
   o_status      OUT VARCHAR2,
   o_msg         OUT VARCHAR2,
   content1      OUT VARCHAR2,
   content2      OUT VARCHAR2)
AS
   c_count NUMBER;
   c_cam NUMBER;
   q_camera VARCHAR2 (30);
   q_cameraid VARCHAR2 (50);
   q_camidx VARCHAR2 (30);
BEGIN
   content1 := NULL;
   content2 := NULL;
   --GET CAMERA INFO
   c_cam := 0;

   DECLARE
      CURSOR cam_cur
      IS
         SELECT d2.spec1, d2.spec3
           FROM sfism4.r_wip_keyparts_t k1, sfism4.r_wip_keyparts_t k2,
                sfis1.c_keyparts_desc_t d1, sfis1.c_keyparts_desc_t d2
          WHERE     k2.serial_number = k1.key_part_sn
                AND d1.key_part_no = k1.key_part_no
                AND d2.key_part_no = k2.key_part_no
                AND d1.TYPE = 'LCD'
                AND d2.TYPE = 'CAMERA'
                AND LENGTH (k1.key_part_sn) = 13
                AND k1.serial_number = q_sn
         UNION ALL
         SELECT a.spec1, a.spec3
           FROM sfism4.r_wip_keyparts_t b, sfis1.c_keyparts_desc_t a,
                sfism4.r_wip_tracking_t w
          WHERE     b.serial_number = w.serial_number
                AND a.key_part_no = b.key_part_no
                AND a.TYPE = 'CAMERA'
                AND LENGTH (b.key_part_sn) <> 13
                AND w.serial_number = q_sn
         UNION ALL
         SELECT d3.spec1, d3.spec3
           FROM sfism4.r_wip_keyparts_t k1, sfism4.r_wip_keyparts_t k2,
                sfism4.r_wip_keyparts_t k3, sfis1.c_keyparts_desc_t d1,
                sfis1.c_keyparts_desc_t d2, sfis1.c_keyparts_desc_t d3
          WHERE     k2.serial_number = k1.key_part_sn
                AND k3.serial_number = k2.key_part_sn
                AND d1.key_part_no = k1.key_part_no
                AND d2.key_part_no = k2.key_part_no
                AND d3.key_part_no = k3.key_part_no
                AND d1.TYPE = 'LCD'
                AND d2.TYPE = 'T/S ASSY'
                AND d3.TYPE = 'CAMERA'
                AND LENGTH (k1.key_part_sn) = 13
                AND k1.serial_number = q_sn
         UNION ALL --20221207 Aaronl_lin
         SELECT d2.spec1, d2.spec3
           FROM sfism4.r_wip_keyparts_t k1, sfism4.r_wip_keyparts_t k2,
                sfis1.c_keyparts_desc_t d1, sfis1.c_keyparts_desc_t d2
          WHERE     k2.serial_number = k1.key_part_sn
                AND d1.key_part_no = k1.key_part_no
                AND d2.key_part_no = k2.key_part_no
                AND d1.TYPE NOT IN 'LCD'
                AND d2.TYPE = 'CAMERA'
                AND LENGTH (k1.key_part_sn) = 13
                AND k1.serial_number = q_sn
         UNION ALL --20230523 Eddie_Ho
         SELECT a.spec1, a.spec3
           FROM sfism4.r_wip_keyparts_t b, sfis1.c_keyparts_desc_t a,
                sfism4.r_wip_tracking_t w
          WHERE     b.serial_number = w.serial_number
                AND a.key_part_no = b.key_part_no
                AND a.TYPE = 'LCD'
                AND w.serial_number = q_sn;

      cam_rec cam_cur%ROWTYPE;
   BEGIN
      FOR cam_rec IN cam_cur
      LOOP
         q_camera := cam_rec.spec1;
         q_cameraid := cam_rec.spec3;
         c_cam := c_cam + 1;
         q_camidx := TO_CHAR (c_cam - 1);

         IF q_camidx = '0'
         THEN
            q_camidx := '';
         END IF;

         content1 :=
               content1
            || 'SET CAMERA'
            || q_camidx
            || '='
            || q_camera
            || CHR (13)
            || CHR (10);
         content2 :=
               content2
            || 'SET CAMERAID'
            || q_camidx
            || '='
            || q_cameraid
            || CHR (13)
            || CHR (10);
      END LOOP;

      WHILE (c_cam < 3)
      LOOP
         q_camidx := TO_CHAR (c_cam);

         IF q_camidx = '0'
         THEN
            q_camidx := '';
         END IF;

         content1 :=
               content1
            || 'SET CAMERA'
            || q_camidx
            || '=EMPTY'
            || CHR (13)
            || CHR (10);
         content2 :=
               content2
            || 'SET CAMERAID'
            || q_camidx
            || '=EMPTY'
            || CHR (13)
            || CHR (10);
         c_cam := c_cam + 1;
      END LOOP;
   END;
--END GET CAMERA INFO
EXCEPTION
   WHEN OTHERS
   THEN
      o_status := 'FAIL';
      o_msg := o_msg || 'Error code :' || SQLCODE || ', Message :';
      o_msg := o_msg || SUBSTR (SQLERRM, 1, 200) || CHR (13) || CHR (10);
END;

CREATE OR REPLACE PROCEDURE SFIS1.c_getbom_lcd (q_sn       IN     VARCHAR2,
                                                o_status      OUT VARCHAR2,
                                                o_msg         OUT VARCHAR2,
                                                content1      OUT VARCHAR2)
AS
   c_count NUMBER;
   q_lcdspec2 VARCHAR2 (30);
   q_lcdsn VARCHAR2 (30);
BEGIN
   content1 := NULL;
   --Get LCD Info
   sfis1.c_getbom_read_spec1in (q_sn, 'LCD PANEL', 'LCD', 'SPEC2', q_lcdspec2, o_status, o_msg);

   IF q_lcdspec2 IS NULL
   THEN
      sfis1.c_getbom_read_spec12n (q_sn, 'LCD PANEL', 'LCD', 'SPEC2', q_lcdspec2, o_status, o_msg);
   END IF;

   IF q_lcdspec2 IS NULL
   THEN
      SELECT COUNT (*)
        INTO c_count
        FROM sfism4.r_wip_keyparts_t b, sfis1.c_keyparts_desc_t a
       WHERE     a.key_part_no = b.key_part_no
             AND a.TYPE LIKE '%LCD%'
             AND LENGTH (b.key_part_sn) = 13
             AND b.serial_number = q_sn;

      IF c_count > 0
      THEN
         SELECT b.key_part_sn
           INTO q_lcdsn
           FROM sfism4.r_wip_keyparts_t b, sfis1.c_keyparts_desc_t a
          WHERE     a.key_part_no = b.key_part_no
                AND a.TYPE LIKE '%LCD%'
                AND LENGTH (b.key_part_sn) = 13
                AND b.serial_number = q_sn
                AND ROWNUM = 1;

         SELECT i.qty + j.qty
           INTO c_count
           FROM (SELECT COUNT (*) qty
                   FROM sfis1.c_keyparts_desc_t d, sfism4.r_wip_keyparts_t k
                  WHERE     d.key_part_no = k.key_part_no
                        AND k.key_part_no LIKE 'AC6%'
                        AND k.serial_number = q_lcdsn) i,
                (SELECT COUNT (*) qty
                   FROM sfism4.r_wip_keyparts_t k2, sfism4.r_wip_keyparts_t k,
                        sfis1.c_keyparts_desc_t d, sfis1.c_keyparts_desc_t d2
                  WHERE     k.key_part_no = d.key_part_no
                        AND k2.serial_number = k.key_part_sn
                        AND k2.key_part_no = d2.key_part_no
                        AND d.TYPE = 'T/S ASSY'
                        AND k2.key_part_no LIKE 'AC6%'
                        AND k.serial_number = q_lcdsn) j;

         IF c_count > 0
         THEN
            SELECT spec2
              INTO q_lcdspec2
              FROM (SELECT d.spec2
                      FROM sfis1.c_keyparts_desc_t d,
                           sfism4.r_wip_keyparts_t k
                     WHERE     d.key_part_no = k.key_part_no
                           AND k.key_part_no LIKE 'AC6%'
                           AND k.serial_number = q_lcdsn
                    UNION
                    SELECT d2.spec2
                      FROM sfism4.r_wip_keyparts_t k2,
                           sfism4.r_wip_keyparts_t k,
                           sfis1.c_keyparts_desc_t d,
                           sfis1.c_keyparts_desc_t d2
                     WHERE     k.key_part_no = d.key_part_no
                           AND k2.serial_number = k.key_part_sn
                           AND k2.key_part_no = d2.key_part_no
                           AND d.TYPE = 'T/S ASSY'
                           AND k2.key_part_no LIKE 'AC6%'
                           AND k.serial_number = q_lcdsn)
             WHERE ROWNUM = 1;
         END IF;

         IF q_lcdspec2 IS NULL
         THEN
            SELECT COUNT (*)
              INTO c_count
              FROM sfism4.r_wip_keyparts_t sf, sfis1.c_keyparts_desc_t c
             WHERE     sf.serial_number IN (SELECT es.key_part_sn
                                              FROM sfism4.r_wip_keyparts_t es
                                             WHERE     es.serial_number =
                                                          q_lcdsn
                                                   AND LENGTH (
                                                       es.key_part_sn) = 13)
                   AND c.key_part_no = sf.key_part_no
                   AND c.TYPE = 'LCD PANEL'
                   AND ROWNUM = 1;

            IF c_count > 0
            THEN
               SELECT c.spec2
                 INTO q_lcdspec2
                 FROM sfism4.r_wip_keyparts_t sf, sfis1.c_keyparts_desc_t c
                WHERE     sf.serial_number IN (SELECT es.key_part_sn
                                                 FROM sfism4.r_wip_keyparts_t es
                                                WHERE     es.serial_number =
                                                             q_lcdsn
                                                      AND LENGTH (
                                                          es.key_part_sn) =
                                                             13)
                      AND c.key_part_no = sf.key_part_no
                      AND c.TYPE = 'LCD PANEL'
                      AND ROWNUM = 1;
            END IF;
         END IF;
      END IF;
   END IF;

   IF q_lcdspec2 IS NULL
   THEN
      --- Get 2D$T6%51#SN $ULCD PANEL SPEC2
      SELECT COUNT (d.spec2)
        INTO c_count
        FROM sfis1.c_keyparts_desc_t d, sfism4.r_wip_keyparts_t k,
             sfism4.r_wip_keyparts_t k2, sfism4.r_wip_keyparts_t k3,
             sfism4.r_wip_keyparts_t k4
       WHERE     LENGTH (k.key_part_sn) = 13
             AND k2.serial_number = k.key_part_sn
             AND LENGTH (k2.key_part_sn) = 13
             AND k3.serial_number = k2.key_part_sn
             AND LENGTH (k3.key_part_sn) = 13
             AND k4.serial_number = k3.key_part_sn
             AND d.key_part_no = k4.key_part_no
             AND d.TYPE = 'LCD PANEL'
             AND k.serial_number = q_sn;

      IF c_count > 0
      THEN
         SELECT d.spec2
           INTO q_lcdspec2
           FROM sfis1.c_keyparts_desc_t d, sfism4.r_wip_keyparts_t k,
                sfism4.r_wip_keyparts_t k2, sfism4.r_wip_keyparts_t k3,
                sfism4.r_wip_keyparts_t k4
          WHERE     LENGTH (k.key_part_sn) = 13
                AND k2.serial_number = k.key_part_sn
                AND LENGTH (k2.key_part_sn) = 13
                AND k3.serial_number = k2.key_part_sn
                AND LENGTH (k3.key_part_sn) = 13
                AND k4.serial_number = k3.key_part_sn
                AND d.key_part_no = k4.key_part_no
                AND d.TYPE = 'LCD PANEL'
                AND k.serial_number = q_sn
                AND ROWNUM = 1;
      ELSE
         q_lcdspec2 := 'EMPTY';
      END IF;
   END IF;

   IF q_lcdspec2 IS NULL
   THEN
      q_lcdspec2 := 'EMPTY';
   END IF;

   content1 := content1 || 'SET LCD=' || q_lcdspec2 || CHR (13) || CHR (10);
--Get LCD Info

EXCEPTION
   WHEN OTHERS
   THEN
      o_status := 'FAIL';
      o_msg := o_msg || 'Error code :' || SQLCODE || ', Message :';
      o_msg := o_msg || SUBSTR (SQLERRM, 1, 200) || CHR (13) || CHR (10);
END;
/

CREATE OR REPLACE PROCEDURE sfis1.c_getbom_lcdfw (q_sn       IN     VARCHAR2,
                                                  o_status      OUT VARCHAR2,
                                                  o_msg         OUT VARCHAR2,
                                                  content1      OUT VARCHAR2)
AS
   c_count NUMBER;
   q_panelspec1 VARCHAR2 (30);
   q_panelspec2 VARCHAR2 (30);
BEGIN
   content1 := NULL;

   --Get LCD PANEL INFO
   SELECT COUNT (*)
     INTO c_count
     FROM sfism4.r_wip_keyparts_t b, sfis1.c_keyparts_desc_t a
    WHERE     a.key_part_no = b.key_part_no
          AND a.TYPE = 'LCD PANEL'
          AND b.serial_number = q_sn;

   IF c_count > 0
   THEN
      SELECT a.spec4, a.spec5
        INTO q_panelspec1, q_panelspec2
        FROM sfism4.r_wip_keyparts_t b, sfis1.c_keyparts_desc_t a
       WHERE     a.key_part_no = b.key_part_no
             AND a.TYPE = 'LCD PANEL'
             AND b.serial_number = q_sn
             AND ROWNUM = 1;

      IF q_panelspec1 IS NULL
      THEN
         q_panelspec1 := 'EMPTY';
      END IF;

      IF q_panelspec2 IS NULL
      THEN
         q_panelspec2 := 'EMPTY';
      END IF;

      content1 :=
         content1 || 'SET LCDFW1=' || q_panelspec1 || CHR (13) || CHR (10);
      content1 :=
         content1 || 'SET LCDFW2=' || q_panelspec2 || CHR (13) || CHR (10);
   ELSE
      content1 := content1 || 'SET LCDFW1=' || CHR (13) || CHR (10);
      content1 := content1 || 'SET LCDFW2=' || CHR (13) || CHR (10);
   END IF;

--Get LCD PANEL INFO
EXCEPTION
   WHEN OTHERS
   THEN
      o_status := 'FAIL';
      o_msg := o_msg || 'Error code :' || SQLCODE || ', Message :';
      o_msg := o_msg || SUBSTR (SQLERRM, 1, 200) || CHR (13) || CHR (10);
END;

CREATE OR REPLACE PROCEDURE sfis1.c_getbom_psensor (
   q_sn       IN     VARCHAR2,
   o_status      OUT VARCHAR2,
   o_msg         OUT VARCHAR2,
   content1      OUT VARCHAR2)
AS
   c_count NUMBER;
   q_psensor VARCHAR2 (30);
BEGIN
   content1 := NULL;
   --GET PSENSOR
   sfis1.c_getbom_read_spec1 (q_sn, 'PSENSOR', 'SPEC1', q_psensor, o_status, o_msg);

   IF q_psensor IS NULL
   THEN
      sfis1.c_getbom_read_spec2in (q_sn, 'PSENSOR', NULL, 'SPEC1', q_psensor, o_status, o_msg);
   END IF;

   IF q_psensor IS NULL
   THEN
      q_psensor := 'EMPTY';
   END IF;

   content1 := content1 || 'SET PSENSOR=' || q_psensor || CHR (13) || CHR (10);
--END PSENSOR
EXCEPTION
   WHEN OTHERS
   THEN
      o_status := 'FAIL';
      o_msg := o_msg || 'Error code :' || SQLCODE || ', Message :';
      o_msg := o_msg || SUBSTR (SQLERRM, 1, 200) || CHR (13) || CHR (10);
END;

CREATE OR REPLACE PROCEDURE sfis1.c_getbom_mic (q_sn       IN     VARCHAR2,
                                                 o_status      OUT VARCHAR2,
                                                 o_msg         OUT VARCHAR2,
                                                 content1      OUT VARCHAR2)
AS
   c_count NUMBER;
   q_mic VARCHAR2 (30);
BEGIN
   content1 := NULL;
    --GET MIC INFO
   sfis1.c_getbom_read_spec1 (q_sn, 'LCD PANEL', 'SPEC3', q_mic, o_status, o_msg);

   IF q_psensor IS NULL
   THEN
       sfis1.c_getbom_read_spec1 (q_sn, 'LCD', 'SPEC3', q_mic, o_status, o_msg);
   END IF;
   IF q_psensor IS NULL
   THEN
       sfis1.c_getbom_read_spec2 (q_sn, 'BASE','LCD PANEL', 'SPEC3', q_mic, o_status, o_msg);
   END IF;
   IF q_psensor IS NULL
   THEN
       sfis1.c_getbom_read_spec2 (q_sn, 'BASE','LCD', 'SPEC3', q_mic, o_status, o_msg);
   END IF;

    IF q_psensor IS NULL
   THEN
      q_psensor := 'EMPTY';
   END IF;
      content1 := content1 || 'SET MIC=' || q_mic || CHR (13) || CHR (10);
   --END GET MIC INFO
EXCEPTION
   WHEN OTHERS
   THEN
      o_status := 'FAIL';
      o_msg := o_msg || 'Error code :' || SQLCODE || ', Message :';
      o_msg := o_msg || SUBSTR (SQLERRM, 1, 200) || CHR (13) || CHR (10);
END;

CREATE OR REPLACE PROCEDURE sfis1.c_getbom_power_cable (
   q_sn       IN     VARCHAR2,
   o_status      OUT VARCHAR2,
   o_msg         OUT VARCHAR2,
   content1      OUT VARCHAR2)
AS
   c_count NUMBER;
   q_pr_cable VARCHAR2 (30);
   q_dw_cable VARCHAR2 (30);
   q_dw_ax VARCHAR2 (30);
BEGIN
   content1 := NULL;

   --GET POWER_CABLE
   SELECT COUNT (*)
     INTO c_count
     FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
    WHERE     a.key_part_no = b.key_part_no
          AND b.TYPE = 'ANTENNA'
          AND a.serial_number = q_sn;

   IF c_count > 0
   THEN
      SELECT b.spec1, b.spec2, b.spec3
        INTO q_pr_cable, q_dw_cable, q_dw_ax
        FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
       WHERE     a.key_part_no = b.key_part_no
             AND b.TYPE = 'ANTENNA'
             AND a.serial_number = q_sn
             AND ROWNUM = 1;
   END IF;

   IF q_pr_cable IS NULL OR q_dw_cable IS NULL OR q_dw_ax IS NULL
   THEN
      SELECT COUNT (*)
        INTO c_count
        FROM sfism4.r_wip_keyparts_t k1, sfism4.r_wip_keyparts_t k2,
             sfis1.c_keyparts_desc_t d1, sfis1.c_keyparts_desc_t d2
       WHERE     k2.serial_number = k1.key_part_sn
             AND d1.key_part_no = k1.key_part_no
             AND d2.key_part_no = k2.key_part_no
             AND d1.TYPE = 'LCD'
             AND d2.TYPE = 'ANTENNA'
             AND k1.serial_number = q_sn;

      IF c_count > 0
      THEN
         SELECT d2.spec1, d2.spec2, d2.spec3
           INTO q_pr_cable, q_dw_cable, q_dw_ax
           FROM sfism4.r_wip_keyparts_t k1, sfism4.r_wip_keyparts_t k2,
                sfis1.c_keyparts_desc_t d1, sfis1.c_keyparts_desc_t d2
          WHERE     k2.serial_number = k1.key_part_sn
                AND d1.key_part_no = k1.key_part_no
                AND d2.key_part_no = k2.key_part_no
                AND d1.TYPE = 'LCD'
                AND d2.TYPE = 'ANTENNA'
                AND k1.serial_number = q_sn
                AND ROWNUM = 1;
      END IF;
   END IF;

   ---Get 2D$T6%51#SN $UANTENNA SPEC1,SPEC2,SPEC3
   IF q_pr_cable IS NULL OR q_dw_cable IS NULL OR q_dw_ax IS NULL
   THEN
      SELECT COUNT (d.spec2)
        INTO c_count
        FROM sfis1.c_keyparts_desc_t d, sfism4.r_wip_keyparts_t k,
             sfism4.r_wip_keyparts_t k2, sfism4.r_wip_keyparts_t k3,
             sfism4.r_wip_keyparts_t k4
       WHERE     LENGTH (k.key_part_sn) = 13
             AND k2.serial_number = k.key_part_sn
             AND LENGTH (k2.key_part_sn) = 13
             AND k3.serial_number = k2.key_part_sn
             AND LENGTH (k3.key_part_sn) = 13
             AND k4.serial_number = k3.key_part_sn
             AND d.key_part_no = k4.key_part_no
             AND d.TYPE = 'ANTENNA'
             AND k.serial_number = q_sn;

      IF c_count > 0
      THEN
         SELECT d.spec1, d.spec2, d.spec3
           INTO q_pr_cable, q_dw_cable, q_dw_ax
           FROM sfis1.c_keyparts_desc_t d, sfism4.r_wip_keyparts_t k,
                sfism4.r_wip_keyparts_t k2, sfism4.r_wip_keyparts_t k3,
                sfism4.r_wip_keyparts_t k4
          WHERE     LENGTH (k.key_part_sn) = 13
                AND k2.serial_number = k.key_part_sn
                AND LENGTH (k2.key_part_sn) = 13
                AND k3.serial_number = k2.key_part_sn
                AND LENGTH (k3.key_part_sn) = 13
                AND k4.serial_number = k3.key_part_sn
                AND d.key_part_no = k4.key_part_no
                AND d.TYPE = 'ANTENNA'
                AND k.serial_number = q_sn
                AND ROWNUM = 1;
      END IF;
   END IF;

   IF q_pr_cable IS NULL
   THEN
      q_pr_cable := 'EMPTY';
   END IF;

   IF q_dw_cable IS NULL
   THEN
      q_dw_cable := 'EMPTY';
   END IF;

   IF q_dw_ax IS NULL
   THEN
      q_dw_ax := 'EMPTY';
   END IF;

   content1 :=
      content1 || 'SET POWER_CABLE=' || q_pr_cable || CHR (13) || CHR (10);
   content1 :=
      content1 || 'SET DARWIN_CABLE=' || q_dw_cable || CHR (13) || CHR (10);
   content1 :=
      content1 || 'SET DARWIN_AX500=' || q_dw_ax || CHR (13) || CHR (10);
--END GET POWER_CABLE

EXCEPTION
   WHEN OTHERS
   THEN
      o_status := 'FAIL';
      o_msg := o_msg || 'Error code :' || SQLCODE || ', Message :';
      o_msg := o_msg || SUBSTR (SQLERRM, 1, 200) || CHR (13) || CHR (10);
END;

CREATE OR REPLACE PROCEDURE sfis1.c_getbom_kb (q_sn       IN     VARCHAR2,
                                               o_status      OUT VARCHAR2,
                                               o_msg         OUT VARCHAR2,
                                               content1      OUT VARCHAR2)
AS
   c_count NUMBER;
   q_kb VARCHAR2 (30);
   q_kbbl VARCHAR2 (30);
   q_kbcode VARCHAR2 (30);
   q_kbpn VARCHAR2 (30);
BEGIN
   content1 := NULL;

   --GET KB/KBBL/KBCODE INFO
   SELECT COUNT (*)
     INTO c_count
     FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
    WHERE     a.key_part_no = b.key_part_no
          AND b.TYPE = 'KB'
          AND a.serial_number = q_sn;

   IF c_count > 0
   THEN
      SELECT b.spec2, b.spec3, b.spec4, b.key_part_no
        INTO q_kb, q_kbbl, q_kbcode, q_kbpn
        FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
       WHERE     a.key_part_no = b.key_part_no
             AND b.TYPE = 'KB'
             AND a.serial_number = q_sn
             AND ROWNUM = 1;
   END IF;

   IF q_kb IS NULL
   THEN
      SELECT COUNT (*)
        INTO c_count
        FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
       WHERE     a.key_part_no = b.key_part_no
             AND b.TYPE = 'K/B'
             AND a.serial_number = q_sn;

      IF c_count > 0
      THEN
         SELECT b.spec2, b.spec3, b.spec4, b.key_part_no
           INTO q_kb, q_kbbl, q_kbcode, q_kbpn
           FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
          WHERE     a.key_part_no = b.key_part_no
                AND b.TYPE = 'K/B'
                AND a.serial_number = q_sn
                AND ROWNUM = 1;
      END IF;
   END IF;

   IF q_kb IS NULL
   THEN
      SELECT COUNT (kd2.spec2)
        INTO c_count
        FROM sfism4.r_wip_keyparts_t wk1, sfism4.r_wip_keyparts_t wk2,
             sfis1.c_keyparts_desc_t kd1, sfis1.c_keyparts_desc_t kd2
       WHERE     wk2.serial_number = wk1.key_part_sn
             AND wk1.key_part_no = kd1.key_part_no
             AND wk2.key_part_no = kd2.key_part_no
             AND kd1.TYPE = 'UPPER'
             AND kd2.TYPE IN ('KB', 'K/B')
             AND wk1.serial_number = q_sn;

      IF c_count > 0
      THEN
         SELECT kd2.spec2, kd2.spec3, kd2.spec4, kd2.key_part_no
           INTO q_kb, q_kbbl, q_kbcode, q_kbpn
           FROM sfism4.r_wip_keyparts_t wk1, sfism4.r_wip_keyparts_t wk2,
                sfis1.c_keyparts_desc_t kd1, sfis1.c_keyparts_desc_t kd2
          WHERE     wk2.serial_number = wk1.key_part_sn
                AND wk1.key_part_no = kd1.key_part_no
                AND wk2.key_part_no = kd2.key_part_no
                AND kd1.TYPE = 'UPPER'
                AND kd2.TYPE IN ('KB', 'K/B')
                AND wk1.serial_number = q_sn
                AND ROWNUM = 1;
      END IF;
   END IF;

   IF q_kb IS NULL
   THEN
      SELECT COUNT (kd2.spec2)
        INTO c_count
        FROM sfism4.r_wip_keyparts_t wk1, sfism4.r_wip_keyparts_t wk2,
             sfis1.c_keyparts_desc_t kd1, sfis1.c_keyparts_desc_t kd2
       WHERE     wk2.serial_number = wk1.key_part_sn
             AND wk1.key_part_no = kd1.key_part_no
             AND wk2.key_part_no = kd2.key_part_no
             AND kd1.TYPE = 'BASE'
             AND kd2.TYPE IN ('KB', 'K/B')
             AND wk1.serial_number = q_sn;

      IF c_count > 0
      THEN
         SELECT kd2.spec2, kd2.spec3, kd2.spec4, kd2.key_part_no
           INTO q_kb, q_kbbl, q_kbcode, q_kbpn
           FROM sfism4.r_wip_keyparts_t wk1, sfism4.r_wip_keyparts_t wk2,
                sfis1.c_keyparts_desc_t kd1, sfis1.c_keyparts_desc_t kd2
          WHERE     wk2.serial_number = wk1.key_part_sn
                AND wk1.key_part_no = kd1.key_part_no
                AND wk2.key_part_no = kd2.key_part_no
                AND kd1.TYPE = 'BASE'
                AND kd2.TYPE IN ('KB', 'K/B')
                AND wk1.serial_number = q_sn
                AND ROWNUM = 1;
      END IF;
   END IF;

   IF q_kb IS NULL
   THEN
      SELECT COUNT (*)
        INTO c_count
        FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
       WHERE     a.key_part_no = b.key_part_no
             AND b.TYPE = 'UPPER'
             AND a.serial_number = q_sn;

      IF c_count > 0
      THEN
         SELECT b.spec9, b.spec10, b.spec4, 'EMPTY'
           INTO q_kb, q_kbbl, q_kbcode, q_kbpn
           FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
          WHERE     a.key_part_no = b.key_part_no
                AND b.TYPE = 'UPPER'
                AND a.serial_number = q_sn
                AND ROWNUM = 1;
      END IF;
   END IF;

   IF q_kb IS NULL
   THEN
      q_kb := 'EMPTY';
   END IF;

   IF q_kbbl IS NULL
   THEN
      q_kbbl := 'EMPTY';
   END IF;

   IF q_kbcode IS NULL
   THEN
      q_kbcode := 'EMPTY';
   END IF;

   IF q_kbpn IS NULL
   THEN
      q_kbpn := 'EMPTY';
   END IF;

   content1 := content1 || 'SET KB=' || q_kb || CHR (13) || CHR (10);
   content1 := content1 || 'SET KBBL=' || q_kbbl || CHR (13) || CHR (10);
   content1 := content1 || 'SET KBCODE=' || q_kbcode || CHR (13) || CHR (10);
   content1 := content1 || 'SET KBPN=' || q_kbpn || CHR (13) || CHR (10);
--END GET KB/KBBL/KBCODE INFO
EXCEPTION
   WHEN OTHERS
   THEN
      o_status := 'FAIL';
      o_msg := o_msg || 'Error code :' || SQLCODE || ', Message :';
      o_msg := o_msg || SUBSTR (SQLERRM, 1, 200) || CHR (13) || CHR (10);
END;

CREATE OR REPLACE PROCEDURE sfis1.c_getbom_battcap (
   q_sn       IN     VARCHAR2,
   o_status      OUT VARCHAR2,
   o_msg         OUT VARCHAR2,
   content1      OUT VARCHAR2)
AS
   c_count NUMBER;
   q_batt VARCHAR2 (30);
   q_batt1 VARCHAR2 (30);
BEGIN
   content1 := NULL;

   --Get BATT Info 20230414 Aaronl_lin
   SELECT COUNT (b.spec2)
     INTO c_count
     FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
    WHERE     a.key_part_no = b.key_part_no
          AND b.TYPE = 'BATT'
          AND a.serial_number = q_sn;

   IF c_count > 0
   THEN
      SELECT b.spec2
        INTO q_batt
        FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
       WHERE     a.key_part_no = b.key_part_no
             AND b.TYPE = 'BATT'
             AND a.serial_number = q_sn
             AND ROWNUM = 1;

      content1 := content1 || 'SET BATTCAP=' || q_batt || CHR (13) || CHR (10);

      IF c_count > 1
      THEN
         SELECT spec2
           INTO q_batt1
           FROM (SELECT ROWNUM rn, b.spec2
                   FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
                  WHERE     a.key_part_no = b.key_part_no
                        AND b.TYPE = 'BATT'
                        AND a.serial_number = q_sn)
          WHERE rn = 2;

         content1 :=
            content1 || 'SET BATTCAP1=' || q_batt1 || CHR (13) || CHR (10);
      ELSE
         content1 := content1 || 'SET BATTCAP1=EMPTY' || CHR (13) || CHR (10);
      END IF;
   ELSE
      SELECT COUNT (kd2.spec2)
        INTO c_count
        FROM sfism4.r_wip_keyparts_t wk1, sfism4.r_wip_keyparts_t wk2,
             sfis1.c_keyparts_desc_t kd1, sfis1.c_keyparts_desc_t kd2
       WHERE     wk2.serial_number = wk1.key_part_sn
             AND wk1.key_part_no = kd1.key_part_no
             AND wk2.key_part_no = kd2.key_part_no
             AND kd1.TYPE = 'UPPER'
             AND kd2.TYPE IN ('BATT')
             AND wk1.serial_number = q_sn;

      IF c_count > 0
      THEN
         SELECT kd2.spec2
           INTO q_batt
           FROM sfism4.r_wip_keyparts_t wk1, sfism4.r_wip_keyparts_t wk2,
                sfis1.c_keyparts_desc_t kd1, sfis1.c_keyparts_desc_t kd2
          WHERE     wk2.serial_number = wk1.key_part_sn
                AND wk1.key_part_no = kd1.key_part_no
                AND wk2.key_part_no = kd2.key_part_no
                AND kd1.TYPE = 'UPPER'
                AND kd2.TYPE IN ('BATT')
                AND wk1.serial_number = q_sn
                AND ROWNUM = 1;

         content1 :=
            content1 || 'SET BATTCAP=' || q_batt || CHR (13) || CHR (10);

         IF c_count > 1
         THEN
            SELECT spec2
              INTO q_batt1
              FROM (SELECT ROWNUM rn, kd2.spec2
                      FROM sfism4.r_wip_keyparts_t wk1,
                           sfism4.r_wip_keyparts_t wk2,
                           sfis1.c_keyparts_desc_t kd1,
                           sfis1.c_keyparts_desc_t kd2
                     WHERE     wk2.serial_number = wk1.key_part_sn
                           AND wk1.key_part_no = kd1.key_part_no
                           AND wk2.key_part_no = kd2.key_part_no
                           AND kd1.TYPE = 'UPPER'
                           AND kd2.TYPE IN ('BATT')
                           AND wk1.serial_number = q_sn)
             WHERE rn = 2;

            content1 :=
               content1 || 'SET BATTCAP1=' || q_batt1 || CHR (13) || CHR (10);
         ELSE
            content1 :=
               content1 || 'SET BATTCAP1=EMPTY' || CHR (13) || CHR (10);
         END IF;
      ELSE
         content1 := content1 || 'SET BATTCAP=EMPTY' || CHR (13) || CHR (10);
         content1 := content1 || 'SET BATTCAP1=EMPTY' || CHR (13) || CHR (10);
      END IF;
   END IF;
--Get BATT Info
EXCEPTION
   WHEN OTHERS
   THEN
      o_status := 'FAIL';
      o_msg := o_msg || 'Error code :' || SQLCODE || ', Message :';
      o_msg := o_msg || SUBSTR (SQLERRM, 1, 200) || CHR (13) || CHR (10);
END;


CREATE OR REPLACE PROCEDURE sfis1.c_getbom_lan_b (q_sn       IN     VARCHAR2,
                                                  o_status      OUT VARCHAR2,
                                                  o_msg         OUT VARCHAR2,
                                                  content1      OUT VARCHAR2)
AS
   c_count NUMBER;
   q_lan_b VARCHAR2 (30);
BEGIN
   content1 := NULL;

   --Get LAN_B Info
   SELECT COUNT (*)
     INTO c_count
     FROM sfis1.c_keyparts_desc_t a, sfis1.c_bom_keypart_t b,
          sfism4.r_wip_tracking_t t
    WHERE     a.key_part_no = b.key_part_no
          AND t.mo_number = b.bom_no
          AND a.TYPE = 'LAN_S/B'
          AND t.serial_number = q_sn;

   IF c_count > 0
   THEN
      SELECT b.key_part_no
        INTO q_lan_b
        FROM sfis1.c_keyparts_desc_t a, sfis1.c_bom_keypart_t b,
             sfism4.r_wip_tracking_t t
       WHERE     a.key_part_no = b.key_part_no
             AND t.mo_number = b.bom_no
             AND a.TYPE = 'LAN_S/B'
             AND t.serial_number = q_sn
             AND ROWNUM = 1;

      content1 := content1 || 'SET LAN_B=' || q_lan_b || CHR (13) || CHR (10);
   ELSE
      content1 := content1 || 'SET LAN_B=EMPTY' || CHR (13) || CHR (10);
   END IF;
--Get LAN_B Info
EXCEPTION
   WHEN OTHERS
   THEN
      o_status := 'FAIL';
      o_msg := o_msg || 'Error code :' || SQLCODE || ', Message :';
      o_msg := o_msg || SUBSTR (SQLERRM, 1, 200) || CHR (13) || CHR (10);
END;


/* Formatted on 2023/9/4 下午 02:57:27 (QP5 v5.256.13226.35538) */
CREATE OR REPLACE PROCEDURE sfis1.c_getbom_ram (q_sn       IN     VARCHAR2,
                                                o_status      OUT VARCHAR2,
                                                o_msg         OUT VARCHAR2,
                                                content1      OUT VARCHAR2,
                                                content2      OUT VARCHAR2)
AS
   c_count NUMBER;
   c_ram NUMBER;
   q_onboardmbqty NUMBER;
   q_ramspec2 VARCHAR2 (30);
   q_ramspec3 VARCHAR2 (30);
   q_ramspec6 VARCHAR2 (30);
   q_ramspec4 VARCHAR2 (30);
   q_ram VARCHAR2 (30);
   q_mb46l VARCHAR2 (30);
   q_onboardspec VARCHAR2 (30);
BEGIN
   content1 := NULL;
   content2 := NULL;

   SELECT COUNT (*)
     INTO c_count
     FROM sfism4.r_wip_tracking_t wt, sfism4.r_wip_keyparts_t w1, sfism4.r_wip_keyparts_t w2,
          sfis1.c_keyparts_desc_t d2
    WHERE     w2.key_part_no = d2.key_part_no
          AND w1.key_part_sn = w2.serial_number
          AND wt.serial_number = w2.key_part_sn
          AND wt.lan_address IS NOT NULL
          AND d2.TYPE IN ('M/B', 'MB')
          AND w1.serial_number = q_sn;

   IF c_count > 0
   THEN
      SELECT d2.key_part_no
        INTO q_mb46l
        FROM sfism4.r_wip_tracking_t wt, sfism4.r_wip_keyparts_t w1, sfism4.r_wip_keyparts_t w2,
             sfis1.c_keyparts_desc_t d2
       WHERE     w2.key_part_no = d2.key_part_no
             AND w1.key_part_sn = w2.serial_number
             AND wt.serial_number = w2.key_part_sn
             AND wt.lan_address IS NOT NULL
             AND d2.TYPE IN ('M/B', 'MB')
             AND w1.serial_number = q_sn;
   ELSE
      SELECT COUNT (*)
        INTO c_count
        FROM sfism4.r_wip_keyparts_t k, sfism4.r_wip_tracking_t p, sfis1.c_keyparts_desc_t d
       WHERE     k.key_part_sn = p.serial_number
             AND p.lan_address IS NOT NULL
             AND k.key_part_no = d.key_part_no
             AND d.TYPE IN ('MB', 'M/B')
             AND k.serial_number = q_sn;

      IF c_count > 0
      THEN
         SELECT k.key_part_no
           INTO q_mb46l
           FROM sfism4.r_wip_keyparts_t k, sfism4.r_wip_tracking_t p, sfis1.c_keyparts_desc_t d
          WHERE     k.key_part_sn = p.serial_number
                AND p.lan_address IS NOT NULL
                AND k.key_part_no = d.key_part_no
                AND d.TYPE IN ('MB', 'M/B')
                AND k.serial_number = q_sn;
      END IF;
   END IF;

   --Get SN RAM/MEMORY Info.
   SELECT COUNT (b.serial_number)
     INTO c_count
     FROM sfism4.r_wip_keyparts_t b, sfis1.c_keyparts_desc_t a, sfism4.r_wip_tracking_t w
    WHERE     b.serial_number = w.serial_number
          AND a.key_part_no = b.key_part_no
          AND w.serial_number = q_sn
          AND a.TYPE = 'RAM';

   IF (c_count > 0)
   THEN
      c_ram := 0;

      DECLARE
         CURSOR ram_cur
         IS
            SELECT a.spec2, a.spec3, a.spec6, a.spec4, a.kp_desc
              FROM sfism4.r_wip_keyparts_t b, sfis1.c_keyparts_desc_t a, sfism4.r_wip_tracking_t w
             WHERE     b.serial_number = w.serial_number
                   AND a.key_part_no = b.key_part_no
                   AND w.serial_number = q_sn
                   AND a.TYPE = 'RAM';

         ram_rec ram_cur%ROWTYPE;
      BEGIN
         FOR ram_rec IN ram_cur
         LOOP
            q_ramspec2 := ram_rec.spec2;
            q_ramspec3 := ram_rec.spec3;
            q_ramspec6 := ram_rec.spec6;
            q_ramspec4 := ram_rec.spec4;
            q_ram := ram_rec.kp_desc;
            c_ram := c_ram + 1;
            content1 := content1 || 'SET RAM' || TO_CHAR (c_ram) || '=' || q_ramspec2 || CHR (13) || CHR (10);
            content1 := content1 || 'SET RAM' || TO_CHAR (c_ram) || 'TP=' || q_ramspec3 || CHR (13) || CHR (10);
            content1 := content1 || 'SET RAM' || TO_CHAR (c_ram) || 'ECC=' || q_ramspec6 || CHR (13) || CHR (10);
            ---Amway_Guo 20180622 Add REQ:Wisper_Meng(SWDL)
            content1 := content1 || 'SET RAMOC' || TO_CHAR (c_ram) || 'TP=' || q_ramspec4 || CHR (13) || CHR (10);
            content2 := content2 || 'SET RAM' || TO_CHAR (c_ram) || 'DESC=' || q_ram || CHR (13) || CHR (10);
         END LOOP;

         WHILE (c_ram < 4)
         LOOP
            content1 := content1 || 'SET RAM' || TO_CHAR (c_ram + 1) || 'TP=EMPTY' || CHR (13) || CHR (10);
            content1 := content1 || 'SET RAM' || TO_CHAR (c_ram + 1) || 'ECC=EMPTY' || CHR (13) || CHR (10);
            ---Amway_Guo 20180622 Add REQ:Wisper_Meng(SWDL)
            content1 := content1 || 'SET RAMOC' || TO_CHAR (c_ram + 1) || 'TP=EMPTY' || CHR (13) || CHR (10);
            content2 := content2 || 'SET RAM' || TO_CHAR (c_ram + 1) || 'DESC=EMPTY' || CHR (13) || CHR (10);
            c_ram := c_ram + 1;
         END LOOP;
      END;
   ELSE
      IF q_onboardmbqty > 0
      THEN
         SELECT COUNT (ckd.pn_desc)
           INTO c_count
           FROM sfis1.c_keyparts_def_t ckd
          WHERE ckd.key_part_no = q_mb46l AND ckd.pn_type = 'SPEC15';

         IF c_count > 0
         THEN
            SELECT ckd.pn_desc
              INTO q_onboardspec
              FROM sfis1.c_keyparts_def_t ckd
             WHERE ckd.key_part_no = q_mb46l AND ckd.pn_type = 'SPEC15';

            content1 := content1 || 'SET RAM1=' || q_onboardspec || CHR (13) || CHR (10);
         END IF;

         SELECT COUNT (ckd.pn_desc)
           INTO c_count
           FROM sfis1.c_keyparts_def_t ckd
          WHERE ckd.key_part_no = q_mb46l AND ckd.pn_type = 'SPEC16';

         IF c_count > 0
         THEN
            SELECT ckd.pn_desc
              INTO q_onboardspec
              FROM sfis1.c_keyparts_def_t ckd
             WHERE ckd.key_part_no = q_mb46l AND ckd.pn_type = 'SPEC16';

            content1 := content1 || 'SET RAM1TP=' || q_onboardspec || CHR (13) || CHR (10);
         END IF;

         SELECT COUNT (ckd.pn_desc)
           INTO c_count
           FROM sfis1.c_keyparts_def_t ckd
          WHERE ckd.key_part_no = q_mb46l AND ckd.pn_type = 'SPEC17';

         IF c_count > 0
         THEN
            SELECT ckd.pn_desc
              INTO q_onboardspec
              FROM sfis1.c_keyparts_def_t ckd
             WHERE ckd.key_part_no = q_mb46l AND ckd.pn_type = 'SPEC17';

            content1 := content1 || 'SET RAM2=' || q_onboardspec || CHR (13) || CHR (10);
         END IF;

         SELECT COUNT (ckd.pn_desc)
           INTO c_count
           FROM sfis1.c_keyparts_def_t ckd
          WHERE ckd.key_part_no = q_mb46l AND ckd.pn_type = 'SPEC18';

         IF c_count > 0
         THEN
            SELECT ckd.pn_desc
              INTO q_onboardspec
              FROM sfis1.c_keyparts_def_t ckd
             WHERE ckd.key_part_no = q_mb46l AND ckd.pn_type = 'SPEC18';

            content1 := content1 || 'SET RAM2TP=' || q_onboardspec || CHR (13) || CHR (10);
         END IF;

         SELECT COUNT (ckd.pn_desc)
           INTO c_count
           FROM sfis1.c_keyparts_def_t ckd
          WHERE ckd.key_part_no = q_mb46l AND ckd.pn_type = 'SPEC19';

         IF c_count > 0
         THEN
            SELECT ckd.pn_desc
              INTO q_onboardspec
              FROM sfis1.c_keyparts_def_t ckd
             WHERE ckd.key_part_no = q_mb46l AND ckd.pn_type = 'SPEC19';

            content1 := content1 || 'SET RAM3=' || q_onboardspec || CHR (13) || CHR (10);
         END IF;

         SELECT COUNT (ckd.pn_desc)
           INTO c_count
           FROM sfis1.c_keyparts_def_t ckd
          WHERE ckd.key_part_no = q_mb46l AND ckd.pn_type = 'SPEC20';

         IF c_count > 0
         THEN
            SELECT ckd.pn_desc
              INTO q_onboardspec
              FROM sfis1.c_keyparts_def_t ckd
             WHERE ckd.key_part_no = q_mb46l AND ckd.pn_type = 'SPEC20';

            content1 := content1 || 'SET RAM3TP=' || q_onboardspec || CHR (13) || CHR (10);
         END IF;

         SELECT COUNT (ckd.pn_desc)
           INTO c_count
           FROM sfis1.c_keyparts_def_t ckd
          WHERE ckd.key_part_no = q_mb46l AND ckd.pn_type = 'SPEC21';

         IF c_count > 0
         THEN
            SELECT ckd.pn_desc
              INTO q_onboardspec
              FROM sfis1.c_keyparts_def_t ckd
             WHERE ckd.key_part_no = q_mb46l AND ckd.pn_type = 'SPEC21';

            content1 := content1 || 'SET RAM4=' || q_onboardspec || CHR (13) || CHR (10);
         END IF;

         SELECT COUNT (ckd.pn_desc)
           INTO c_count
           FROM sfis1.c_keyparts_def_t ckd
          WHERE ckd.key_part_no = q_mb46l AND ckd.pn_type = 'SPEC22';

         IF c_count > 0
         THEN
            SELECT ckd.pn_desc
              INTO q_onboardspec
              FROM sfis1.c_keyparts_def_t ckd
             WHERE ckd.key_part_no = q_mb46l AND ckd.pn_type = 'SPEC22';

            content1 := content1 || 'SET RAM4TP=' || q_onboardspec || CHR (13) || CHR (10);
         END IF;
      ELSE
         content1 := content1 || 'SET RAM=EMPTY' || CHR (13) || CHR (10);
      END IF;
   END IF;
--END GET SN RAM/MEMORY INFO.

EXCEPTION
   WHEN OTHERS
   THEN
      o_status := 'FAIL';
      o_msg := o_msg || 'Error code :' || SQLCODE || ', Message :';
      o_msg := o_msg || SUBSTR (SQLERRM, 1, 200) || CHR (13) || CHR (10);
END;


CREATE OR REPLACE PROCEDURE sfis1.c_getbom_hdd (q_sn       IN     VARCHAR2,
                                                o_status      OUT VARCHAR2,
                                                o_msg         OUT VARCHAR2,
                                                content1      OUT VARCHAR2,
                                                content2      OUT VARCHAR2)
AS
   c_count NUMBER;
   q_mhdd_sqty NUMBER;
   q_mhdd NUMBER;
   c_hdd NUMBER;
   q_onboardmbqty NUMBER;
   q_mb46l VARCHAR2 (30);
   q_bootdpn VARCHAR2 (30);
   q_bootkpr VARCHAR2 (30);
   q_model VARCHAR2 (30);
   q_hddspec1 VARCHAR2 (30);
   q_hddspec2 VARCHAR2 (30);
   q_hddflag VARCHAR2 (30);
   q_hdd_kpn VARCHAR2 (30);
   q_hdd_kpdesc VARCHAR2 (150);
   q_hdd_kps VARCHAR2 (30);
   q_hdd_kpr VARCHAR2 (30);
   q_onboardspec VARCHAR2 (150);
BEGIN
   content1 := NULL;
   content2 := NULL;
   SELECT m.model_name
     INTO q_model
     FROM sfism4.r_mo_base_t m, sfism4.r_wip_tracking_t w
    WHERE w.mo_number = m.mo_number AND w.serial_number = q_sn;

   SELECT COUNT (*)
     INTO c_count
     FROM sfism4.r_wip_tracking_t wt, sfism4.r_wip_keyparts_t w1, sfism4.r_wip_keyparts_t w2,
          sfis1.c_keyparts_desc_t d2
    WHERE     w2.key_part_no = d2.key_part_no
          AND w1.key_part_sn = w2.serial_number
          AND wt.serial_number = w2.key_part_sn
          AND wt.lan_address IS NOT NULL
          AND d2.TYPE IN ('M/B', 'MB')
          AND w1.serial_number = q_sn;

   IF c_count > 0
   THEN
      SELECT d2.key_part_no
        INTO q_mb46l
        FROM sfism4.r_wip_tracking_t wt, sfism4.r_wip_keyparts_t w1, sfism4.r_wip_keyparts_t w2,
             sfis1.c_keyparts_desc_t d2
       WHERE     w2.key_part_no = d2.key_part_no
             AND w1.key_part_sn = w2.serial_number
             AND wt.serial_number = w2.key_part_sn
             AND wt.lan_address IS NOT NULL
             AND d2.TYPE IN ('M/B', 'MB')
             AND w1.serial_number = q_sn;
   ELSE
      SELECT COUNT (*)
        INTO c_count
        FROM sfism4.r_wip_keyparts_t k, sfism4.r_wip_tracking_t p, sfis1.c_keyparts_desc_t d
       WHERE     k.key_part_sn = p.serial_number
             AND p.lan_address IS NOT NULL
             AND k.key_part_no = d.key_part_no
             AND d.TYPE IN ('MB', 'M/B')
             AND k.serial_number = q_sn;

      IF c_count > 0
      THEN
         SELECT k.key_part_no
           INTO q_mb46l
           FROM sfism4.r_wip_keyparts_t k, sfism4.r_wip_tracking_t p, sfis1.c_keyparts_desc_t d
          WHERE     k.key_part_sn = p.serial_number
                AND p.lan_address IS NOT NULL
                AND k.key_part_no = d.key_part_no
                AND d.TYPE IN ('MB', 'M/B')
                AND k.serial_number = q_sn;
      END IF;
   END IF;

   --GET SN HDD INFO.
   SELECT COUNT (cpi.prg_name)
     INTO q_mhdd_sqty
     FROM sfis1.c_parameter_ini cpi
    WHERE     cpi.prg_name = 'SFC2034A31'
          AND cpi.vr_class = 'Rialto MLK'
          AND cpi.vr_item = 'SLOT'
          AND cpi.vr_value = q_model;

   q_mhdd := 0;

   SELECT COUNT (*)
     INTO c_count
     FROM sfism4.r_wip_tracking_t wt, sfism4.r_mo_base_t mb
    WHERE wt.mo_number = mb.mo_number AND mb.mo_type1 = 'MHDD' AND wt.serial_number = q_sn;

   IF c_count > 0
   THEN
      q_mhdd := 1;
   ELSE
      ---PM:MayX_Xu Special MainHdd Logic 20210329  Amway_Guo
      SELECT COUNT (cpi.prg_name)
        INTO c_count
        FROM sfis1.c_parameter_ini cpi
       WHERE     cpi.prg_name = 'SFC2034A31'
             AND cpi.vr_class = 'HDD_MIN_SIZE'
             AND cpi.vr_item = 'SLOT'
             AND cpi.vr_value = q_model;

      IF c_count > 0
      THEN
         q_mhdd := 1;
      END IF;
   END IF;

   ---?寞??HDD璈車嚗?OOTDRIVE嚗??ain/Second, @2023/04/06 add by Aaronl_lin
   IF q_mhdd = 1
   THEN
      SELECT COUNT (*)
        INTO c_count
        FROM sfis1.c_parameter_ini es
       WHERE     es.prg_name = 'A31BRPDLImpl'
             AND es.vr_class = 'BOOT_DRIVE'
             AND es.vr_item = 'SPECIAL'
             AND es.vr_name = 'MODEL'
             AND es.vr_value = q_model;

      IF c_count > 0
      THEN
         SELECT COUNT (ps.si_data)
           INTO c_count
           FROM sfism4.r_po_si_t ps, sfism4.r_mo_base_t mb
          WHERE     ps.po_number = mb.po_no
                AND ps.line = 'GCF_HW'
                AND ps.si_type = 'MHDD'
                AND mb.mo_number = SUBSTR (q_sn, 0, 8);

         IF c_count > 0
         THEN
            SELECT ps.si_data
              INTO q_bootdpn
              FROM sfism4.r_po_si_t ps, sfism4.r_mo_base_t mb
             WHERE     ps.po_number = mb.po_no
                   AND ps.line = 'GCF_HW'
                   AND ps.si_type = 'MHDD'
                   AND mb.mo_number = SUBSTR (q_sn, 0, 8);

            q_bootdpn := '%' + q_bootdpn + '%';

            SELECT COUNT (bk.kp_relation)
              INTO c_count
              FROM sfis1.c_bom_keypart_t bk
             WHERE     bk.bom_no = SUBSTR (q_sn, 0, 8)
                   AND bk.part_mode = 'H'
                   AND bk.key_part_no IN (SELECT pm.compal_part_no
                                            FROM sfis1.c_part_map_t pm
                                           WHERE pm.cust_no = 'A31' AND pm.cust_part_no LIKE q_bootdpn);

            IF c_count > 0
            THEN
               SELECT bk.kp_relation
                 INTO q_bootkpr
                 FROM sfis1.c_bom_keypart_t bk
                WHERE     bk.bom_no = SUBSTR (q_sn, 0, 8)
                      AND bk.part_mode = 'H'
                      AND bk.key_part_no IN (SELECT pm.compal_part_no
                                               FROM sfis1.c_part_map_t pm
                                              WHERE pm.cust_no = 'A31' AND pm.cust_part_no LIKE q_bootdpn);
            END IF;
         END IF;
      END IF;
   END IF;

   SELECT COUNT (k2.serial_number)
     INTO c_count
     FROM sfism4.r_wip_keyparts_t k1, sfism4.r_wip_keyparts_t k2, sfis1.c_keyparts_desc_t d1,
          sfis1.c_keyparts_desc_t d2
    WHERE     k2.serial_number = k1.key_part_sn
          AND d1.key_part_no = k1.key_part_no
          AND d2.key_part_no = k2.key_part_no --AND D1.TYPE = 'HDD'
          AND d2.TYPE = 'HDD'
          AND LENGTH (k1.key_part_sn) = 13
          AND k1.serial_number = q_sn;

   IF (c_count = 0)
   THEN
      SELECT COUNT (b.serial_number)
        INTO c_count
        FROM sfism4.r_wip_keyparts_t b, sfis1.c_keyparts_desc_t a, sfism4.r_wip_tracking_t w
       WHERE     b.serial_number = w.serial_number
             AND a.key_part_no = b.key_part_no
             AND a.TYPE = 'HDD'
             AND LENGTH (b.key_part_sn) <> 13
             AND w.serial_number = q_sn;
   END IF;

   IF (c_count > 0)
   THEN
      c_hdd := 0;

      DECLARE
         CURSOR hdd_cur
         IS
            SELECT d2.spec1, d2.spec2, k1.sps_flag, k1.key_part_no, d1.kp_desc, k2.key_part_sn || k2.version AS kps,
                   k2.kp_relation AS kpr
              FROM sfism4.r_wip_keyparts_t k1, sfism4.r_wip_keyparts_t k2, sfis1.c_keyparts_desc_t d1,
                   sfis1.c_keyparts_desc_t d2
             WHERE     k2.serial_number = k1.key_part_sn
                   AND d1.key_part_no = k1.key_part_no
                   AND d2.key_part_no = k2.key_part_no
                   --AND D1.TYPE = 'HDD'
                   AND d2.TYPE = 'HDD'
                   AND LENGTH (k1.key_part_sn) = 13
                   AND k1.serial_number = q_sn
            UNION ALL
            SELECT a.spec1, a.spec2, b.sps_flag, b.key_part_no, a.kp_desc, b.key_part_sn || b.version AS kps,
                   b.kp_relation AS kpr
              FROM sfism4.r_wip_keyparts_t b, sfis1.c_keyparts_desc_t a, sfism4.r_wip_tracking_t w
             WHERE     b.serial_number = w.serial_number
                   AND a.key_part_no = b.key_part_no
                   AND a.TYPE = 'HDD'
                   AND LENGTH (b.key_part_sn) <> 13
                   AND w.serial_number = q_sn;

         hdd_rec hdd_cur%ROWTYPE;
      BEGIN
         FOR hdd_rec IN hdd_cur
         LOOP
            q_hddspec1 := hdd_rec.spec1;
            q_hddspec2 := hdd_rec.spec2;
            q_hddflag := hdd_rec.sps_flag;
            q_hdd_kpn := hdd_rec.key_part_no;
            q_hdd_kpdesc := hdd_rec.kp_desc;
            q_hdd_kps := hdd_rec.kps;
            q_hdd_kpr := hdd_rec.kpr;
            c_hdd := c_hdd + 1;
            content1 := content1 || 'SET HDD' || TO_CHAR (c_hdd) || 'SZ=' || q_hddspec2 || CHR (13) || CHR (10);

            IF hdd_rec.spec1 IS NOT NULL
            THEN
               content1 := content1 || 'SET FDE' || TO_CHAR (c_hdd) || '=' || q_hddspec1 || CHR (13) || CHR (10);
            ELSE
               content1 := content1 || 'SET FDE' || TO_CHAR (c_hdd) || '=HDD' || CHR (13) || CHR (10);
            END IF;

            IF ( (hdd_rec.sps_flag = 'Y' OR (hdd_rec.sps_flag = '5' AND q_mhdd_sqty = 0)) AND q_mhdd = 1)
            THEN
               content1 := content1 || 'SET HDD' || TO_CHAR (c_hdd) || 'MAIN=Y' || CHR (13) || CHR (10);
            END IF;

            ---Aaronl_lin 20230406 Add
            IF ( (hdd_rec.sps_flag = 'S' OR (hdd_rec.sps_flag = '4' AND q_mhdd_sqty = 0)) AND q_mhdd = 1)
            THEN
               content1 := content1 || 'SET HDD' || TO_CHAR (c_hdd) || 'SECOND=Y' || CHR (13) || CHR (10);
            END IF;

            ---Aaronl_lin 20230406 AddHDD BOOT_DRIVE
            IF q_bootkpr IS NOT NULL
            THEN
               IF (hdd_rec.kpr = q_bootkpr)
               THEN
                  content1 := content1 || 'SET HDD' || TO_CHAR (c_hdd) || 'BOOT_DRIVE=Y' || CHR (13) || CHR (10);
               END IF;
            END IF;

            ---Amway_Guo  20210412 Rialto MLK15/17 Logic Add REQ:LeonGM_Chen  PM:Hausen_Jiang QA:Ada_Fang
            IF (q_mhdd_sqty > 0)
            THEN
               IF (hdd_rec.sps_flag IS NOT NULL)
               THEN
                  content2 := content2 || 'SET SLOT' || hdd_rec.sps_flag || 'HDD=' || q_hddspec2 || CHR (13) || CHR (10);
               END IF;
            END IF;

            ---Amway_Guo 20180621 Add REQ:Darin_Zhao
            IF (LENGTH (q_hdd_kps) > 23)
            THEN
               content1 :=
                     content1
                  || 'SET HDD'
                  || TO_CHAR (c_hdd)
                  || 'PPID='
                  || SUBSTR (q_hdd_kps, 0, 23)
                  || CHR (13)
                  || CHR (10);
            ELSE
               content1 := content1 || 'SET HDD' || TO_CHAR (c_hdd) || 'PPID=' || q_hdd_kps || CHR (13) || CHR (10);
            END IF;

            ---Amway_Guo 20180621 Add REQ:Darin_Zhao
            IF ( ( (INSTR (q_hdd_kpdesc, 'CFI') > 0) OR (INSTR (q_hdd_kpdesc, 'RELAB') > 0)) /* AND
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      (SUBSTR(Q_HDD_KPN, 0, 2) = '51')*/
                                                                                            )
            THEN
               ---Amway_Guo 20190909 remove AND(SUBSTR(Q_HDD_KPN, 0, 2) = '51') REQ:Darin_Zhao
               content1 := content1 || 'SET RELABEL' || TO_CHAR (c_hdd) || '=Y' || CHR (13) || CHR (10);
            ELSE
               content1 := content1 || 'SET RELABEL' || TO_CHAR (c_hdd) || '=N' || CHR (13) || CHR (10);
            END IF;
         END LOOP;

         WHILE (c_hdd < 4)
         LOOP
            content1 := content1 || 'SET HDD' || TO_CHAR (c_hdd + 1) || 'SZ=EMPTY' || CHR (13) || CHR (10);
            content1 := content1 || 'SET FDE' || TO_CHAR (c_hdd + 1) || '=HDD' || CHR (13) || CHR (10);
            ---Amway_Guo 20180621 Add REQ:Darin_Zhao
            content1 := content1 || 'SET HDD' || TO_CHAR (c_hdd + 1) || 'PPID=EMPTY' || CHR (13) || CHR (10);
            ---Amway_Guo 20180621 Add REQ:Darin_Zhao
            content1 := content1 || 'SET RELABEL' || TO_CHAR (c_hdd + 1) || '=EMPTY' || CHR (13) || CHR (10);
            c_hdd := c_hdd + 1;
         END LOOP;
      END;
   ELSE
      IF q_onboardmbqty > 0
      THEN
         SELECT COUNT (ckd.pn_desc)
           INTO c_count
           FROM sfis1.c_keyparts_def_t ckd
          WHERE ckd.key_part_no = q_mb46l AND ckd.pn_type = 'SPEC11';

         IF c_count > 0
         THEN
            SELECT ckd.pn_desc
              INTO q_onboardspec
              FROM sfis1.c_keyparts_def_t ckd
             WHERE ckd.key_part_no = q_mb46l AND ckd.pn_type = 'SPEC11';

            content1 := content1 || 'SET HDD1SZ=' || q_onboardspec || CHR (13) || CHR (10);
         END IF;

         SELECT COUNT (ckd.pn_desc)
           INTO c_count
           FROM sfis1.c_keyparts_def_t ckd
          WHERE ckd.key_part_no = q_mb46l AND ckd.pn_type = 'SPEC12';

         IF c_count > 0
         THEN
            SELECT ckd.pn_desc
              INTO q_onboardspec
              FROM sfis1.c_keyparts_def_t ckd
             WHERE ckd.key_part_no = q_mb46l AND ckd.pn_type = 'SPEC12';

            content1 := content1 || 'SET HDD2SZ=' || q_onboardspec || CHR (13) || CHR (10);
         END IF;

         SELECT COUNT (ckd.pn_desc)
           INTO c_count
           FROM sfis1.c_keyparts_def_t ckd
          WHERE ckd.key_part_no = q_mb46l AND ckd.pn_type = 'SPEC13';

         IF c_count > 0
         THEN
            SELECT ckd.pn_desc
              INTO q_onboardspec
              FROM sfis1.c_keyparts_def_t ckd
             WHERE ckd.key_part_no = q_mb46l AND ckd.pn_type = 'SPEC13';

            content1 := content1 || 'SET HDD3SZ=' || q_onboardspec || CHR (13) || CHR (10);
         END IF;

         SELECT COUNT (ckd.pn_desc)
           INTO c_count
           FROM sfis1.c_keyparts_def_t ckd
          WHERE ckd.key_part_no = q_mb46l AND ckd.pn_type = 'SPEC14';

         IF c_count > 0
         THEN
            SELECT ckd.pn_desc
              INTO q_onboardspec
              FROM sfis1.c_keyparts_def_t ckd
             WHERE ckd.key_part_no = q_mb46l AND ckd.pn_type = 'SPEC14';

            content1 := content1 || 'SET HDD4SZ=' || q_onboardspec || CHR (13) || CHR (10);
         END IF;
      ELSE
         content1 := content1 || 'SET HDD=EMPTY' || CHR (13) || CHR (10);
         content1 := content1 || 'SET HDDPPID=EMPTY' || CHR (13) || CHR (10);
      END IF;
   END IF;

   ---Amway_Guo  20210412 Rialto MLK15/17 Logic Add REQ:LeonGM_Chen  PM:Hausen_Jiang QA:Ada_Fang
   ---No HDD Assemble Sequence show EMPTY
   IF (q_mhdd_sqty > 0)
   THEN
      SELECT COUNT (b.key_part_sn)
        INTO c_count
        FROM sfism4.r_wip_keyparts_t b, sfis1.c_keyparts_desc_t a
       WHERE b.serial_number = q_sn AND a.key_part_no = b.key_part_no AND a.TYPE = 'HDD' AND b.sps_flag = '6';

      IF c_count = 0
      THEN
         content2 := content2 || 'SET SLOT6HDD=EMPTY' || CHR (13) || CHR (10);
      END IF;

      SELECT COUNT (b.key_part_sn)
        INTO c_count
        FROM sfism4.r_wip_keyparts_t b, sfis1.c_keyparts_desc_t a
       WHERE b.serial_number = q_sn AND a.key_part_no = b.key_part_no AND a.TYPE = 'HDD' AND b.sps_flag = '5';

      IF c_count = 0
      THEN
         content2 := content2 || 'SET SLOT5HDD=EMPTY' || CHR (13) || CHR (10);
      END IF;

      SELECT COUNT (b.key_part_sn)
        INTO c_count
        FROM sfism4.r_wip_keyparts_t b, sfis1.c_keyparts_desc_t a
       WHERE b.serial_number = q_sn AND a.key_part_no = b.key_part_no AND a.TYPE = 'HDD' AND b.sps_flag = '4';

      IF c_count = 0
      THEN
         content2 := content2 || 'SET SLOT4HDD=EMPTY' || CHR (13) || CHR (10);
      END IF;

      SELECT COUNT (b.key_part_sn)
        INTO c_count
        FROM sfism4.r_wip_keyparts_t b, sfis1.c_keyparts_desc_t a
       WHERE b.serial_number = q_sn AND a.key_part_no = b.key_part_no AND a.TYPE = 'HDD' AND b.sps_flag = '3';

      IF c_count = 0
      THEN
         content2 := content2 || 'SET SLOT3HDD=EMPTY' || CHR (13) || CHR (10);
      END IF;
   END IF;
--END Get SN HDD Info.
EXCEPTION
   WHEN OTHERS
   THEN
      o_status := 'FAIL';
      o_msg := o_msg || 'Error code :' || SQLCODE || ', Message :';
      o_msg := o_msg || SUBSTR (SQLERRM, 1, 200) || CHR (13) || CHR (10);
END;


CREATE OR REPLACE PROCEDURE sfis1.c_getbom_cpu (q_sn       IN     VARCHAR2,
                                                o_status      OUT VARCHAR2,
                                                o_msg         OUT VARCHAR2,
                                                content1      OUT VARCHAR2)
AS
   c_count NUMBER;
   q_cpuspec2 VARCHAR2 (30);
   q_cpuspec3 VARCHAR2 (30);
   q_mbspec6 VARCHAR2 (30);
BEGIN
   content1 := NULL;

   SELECT COUNT (*)
     INTO c_count
     FROM sfism4.r_wip_tracking_t wt, sfism4.r_wip_keyparts_t w1, sfism4.r_wip_keyparts_t w2,
          sfis1.c_keyparts_desc_t d2
    WHERE     w2.key_part_no = d2.key_part_no
          AND w1.key_part_sn = w2.serial_number
          AND wt.serial_number = w2.key_part_sn
          AND wt.lan_address IS NOT NULL
          AND d2.TYPE IN ('M/B', 'MB')
          AND w1.serial_number = q_sn;

   IF c_count > 0
   THEN
      SELECT d2.spec6
        INTO q_mbspec6
        FROM sfism4.r_wip_tracking_t wt, sfism4.r_wip_keyparts_t w1, sfism4.r_wip_keyparts_t w2,
             sfis1.c_keyparts_desc_t d2
       WHERE     w2.key_part_no = d2.key_part_no
             AND w1.key_part_sn = w2.serial_number
             AND wt.serial_number = w2.key_part_sn
             AND wt.lan_address IS NOT NULL
             AND d2.TYPE IN ('M/B', 'MB')
             AND w1.serial_number = q_sn;
   ELSE
      SELECT COUNT (*)
        INTO c_count
        FROM sfism4.r_wip_keyparts_t k, sfism4.r_wip_tracking_t p, sfis1.c_keyparts_desc_t d
       WHERE     k.key_part_sn = p.serial_number
             AND p.lan_address IS NOT NULL
             AND k.key_part_no = d.key_part_no
             AND d.TYPE IN ('MB', 'M/B')
             AND k.serial_number = q_sn;

      IF c_count > 0
      THEN
         SELECT d.spec6
           INTO q_mbspec6
           FROM sfism4.r_wip_keyparts_t k, sfism4.r_wip_tracking_t p, sfis1.c_keyparts_desc_t d
          WHERE     k.key_part_sn = p.serial_number
                AND p.lan_address IS NOT NULL
                AND k.key_part_no = d.key_part_no
                AND d.TYPE IN ('MB', 'M/B')
                AND k.serial_number = q_sn;
      END IF;
   END IF;

   --GET CPU INFO
   SELECT COUNT (*)
     INTO c_count
     FROM sfism4.r_wip_keyparts_t b, sfis1.c_keyparts_desc_t a, sfism4.r_wip_tracking_t w
    WHERE     b.serial_number = w.serial_number
          AND a.key_part_no = b.key_part_no
          AND w.serial_number = q_sn
          AND a.TYPE = 'CPU';

   IF c_count > 0
   THEN
      SELECT a.spec2, a.spec3
        INTO q_cpuspec2, q_cpuspec3
        FROM sfism4.r_wip_keyparts_t b, sfis1.c_keyparts_desc_t a, sfism4.r_wip_tracking_t w
       WHERE     b.serial_number = w.serial_number
             AND a.key_part_no = b.key_part_no
             AND w.serial_number = q_sn
             AND a.TYPE = 'CPU'
             AND ROWNUM = 1;
   END IF;

   IF q_cpuspec2 IS NULL
   THEN
      q_cpuspec2 := 'EMPTY';
   END IF;

   IF q_mbspec6 IS NULL
   THEN
      q_mbspec6 := 'EMPTY';
   END IF;

   IF q_cpuspec3 IS NULL
   THEN
      q_cpuspec3 := q_mbspec6;
   END IF;

   content1 := content1 || 'SET CPUSP=' || q_cpuspec2 || CHR (13) || CHR (10);
   content1 := content1 || 'SET CPUTP=' || q_cpuspec3 || CHR (13) || CHR (10);
--END GET CPU INFO
EXCEPTION
   WHEN OTHERS
   THEN
      o_status := 'FAIL';
      o_msg := o_msg || 'Error code :' || SQLCODE || ', Message :';
      o_msg := o_msg || SUBSTR (SQLERRM, 1, 200) || CHR (13) || CHR (10);
END;

CREATE OR REPLACE PROCEDURE sfis1.c_getbom_odd (q_sn       IN     VARCHAR2,
                                                o_status      OUT VARCHAR2,
                                                o_msg         OUT VARCHAR2,
                                                content1      OUT VARCHAR2)
AS
   c_count NUMBER;
   q_odd VARCHAR2 (30);
BEGIN
   content1 := NULL;
   --GET ODD INFO
   sfis1.c_getbom_read_spec1 (q_sn, 'ODD', 'SPEC2', q_odd, o_status, o_msg);
   IF q_odd IS NOT NULL
   THEN
      content1 := content1 || 'SET ODD=' || q_odd || CHR (13) || CHR (10);
   ELSE
      content1 := content1 || 'SET ODD=EMPTY' || CHR (13) || CHR (10);
   END IF;
--END GET ODD INFO
EXCEPTION
   WHEN OTHERS
   THEN
      o_status := 'FAIL';
      o_msg := o_msg || 'Error code :' || SQLCODE || ', Message :';
      o_msg := o_msg || SUBSTR (SQLERRM, 1, 200) || CHR (13) || CHR (10);
END;

CREATE OR REPLACE PROCEDURE sfis1.c_getbom_blue (q_sn       IN     VARCHAR2,
                                                 o_status      OUT VARCHAR2,
                                                 o_msg         OUT VARCHAR2,
                                                 content1      OUT VARCHAR2)
AS
   c_count NUMBER;
   q_blue VARCHAR2 (30);
BEGIN
   content1 := NULL;
   --GET BLUETOOTH INFO
   sfis1.c_getbom_read_spec1 (q_sn, 'BT', 'SPEC2', q_blue, o_status, o_msg);

   IF q_blue IS NULL
   THEN
      SELECT COUNT (*)
        INTO c_count
        FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
       WHERE a.key_part_no = b.key_part_no AND b.TYPE = 'WLAN' AND a.serial_number = q_sn AND b.spec3 IS NOT NULL;

      IF c_count > 0
      THEN
         SELECT b.spec3
           INTO q_blue
           FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
          WHERE     a.key_part_no = b.key_part_no
                AND b.TYPE = 'WLAN'
                AND a.serial_number = q_sn
                AND b.spec3 IS NOT NULL
                AND ROWNUM = 1;
      END IF;
   END IF;

   IF q_blue IS NULL
   THEN
      content1 := content1 || 'SET BLUE=EMPTY' || CHR (13) || CHR (10);
   ELSE
      content1 := content1 || 'SET BLUE=' || q_blue || CHR (13) || CHR (10);
   END IF; 
   --END GET BLUETOOTH INFO
EXCEPTION
   WHEN OTHERS
   THEN
      o_status := 'FAIL';
      o_msg := o_msg || 'Error code :' || SQLCODE || ', Message :';
      o_msg := o_msg || SUBSTR (SQLERRM, 1, 200) || CHR (13) || CHR (10);
END;

CREATE OR REPLACE PROCEDURE sfis1.c_getbom_wlan (q_sn       IN     VARCHAR2,
                                                 o_status      OUT VARCHAR2,
                                                 o_msg         OUT VARCHAR2,
                                                 content1      OUT VARCHAR2)
AS
   c_count NUMBER;
   q_iobwlan VARCHAR2 (30);
   q_wlan1spec1 VARCHAR2 (30);
   q_wlan1spec2 VARCHAR2 (30);
   q_wlan2spec1 VARCHAR2 (30);
   q_wlan2spec2 VARCHAR2 (30);
   q_model VARCHAR2 (30);
BEGIN
   content1 := NULL;
   SELECT m.model_name
     INTO q_model
     FROM sfism4.r_mo_base_t m, sfism4.r_wip_tracking_t w
    WHERE w.mo_number = m.mo_number AND w.serial_number = q_sn;
   --Get Wimax&Wlan Info
   SELECT COUNT (*)
     INTO c_count
     FROM sfis1.c_parameter_ini es
    WHERE     es.prg_name = 'A31BRPDLImpl'
          AND es.vr_class = 'MODEL_NAME'
          AND es.vr_item = 'MODEL_NAME'
          AND es.vr_name = 'MODEL_NAME'
          AND es.vr_value = q_model;

   IF c_count > 0
   THEN
      SELECT COUNT (*)
        INTO c_count
        FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
       WHERE a.key_part_no = b.key_part_no AND b.TYPE = 'IO/B' AND b.spec2 IS NOT NULL AND a.serial_number = q_sn;

      IF c_count > 0
      THEN
         SELECT b.spec2
           INTO q_iobwlan
           FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
          WHERE     a.key_part_no = b.key_part_no
                AND b.TYPE = 'IO/B'
                AND b.spec2 IS NOT NULL
                AND a.serial_number = q_sn
                AND ROWNUM = 1;
      END IF;
   END IF;

   SELECT COUNT (*)
     INTO c_count
     FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
    WHERE a.key_part_no = b.key_part_no AND b.TYPE = 'WLAN' AND a.serial_number = q_sn;

   IF c_count > 0
   THEN
      SELECT b.spec1, b.spec2
        INTO q_wlan1spec1, q_wlan1spec2
        FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
       WHERE a.key_part_no = b.key_part_no AND b.TYPE = 'WLAN' AND a.serial_number = q_sn AND ROWNUM = 1;
   END IF;

   IF c_count > 1
   THEN
      SELECT spec1, spec2
        INTO q_wlan2spec1, q_wlan2spec2
        FROM (SELECT ROWNUM rr, b.spec1, b.spec2
                FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
               WHERE a.key_part_no = b.key_part_no AND b.TYPE = 'WLAN' AND a.serial_number = q_sn)
       WHERE rr = 2;
   END IF;

   IF q_wlan1spec2 IS NULL AND q_iobwlan IS NOT NULL
   THEN
      content1 := content1 || 'SET WLAN=' || q_iobwlan || CHR (13) || CHR (10);
   ELSE
      IF q_wlan1spec2 IS NOT NULL
      THEN
         content1 := content1 || 'SET WLAN=' || q_wlan1spec2 || CHR (13) || CHR (10);
      ELSE
         content1 := content1 || 'SET WLAN=EMPTY' || CHR (13) || CHR (10);
      END IF;
   END IF;

   IF q_wlan1spec1 = 'WIMAX'
   THEN
      content1 := content1 || 'SET WIMAX_LABEL=Y' || CHR (13) || CHR (10);
   ELSE
      content1 := content1 || 'SET WIMAX_LABEL=N' || CHR (13) || CHR (10);
   END IF;

   IF q_wlan2spec2 IS NOT NULL
   THEN
      content1 := content1 || 'SET WLAN1=' || q_wlan2spec2 || CHR (13) || CHR (10);
   ELSE
      content1 := content1 || 'SET WLAN1=EMPTY' || CHR (13) || CHR (10);
   END IF;

   IF q_wlan2spec1 = 'WIMAX'
   THEN
      content1 := content1 || 'SET WIMAX_LABEL1=Y' || CHR (13) || CHR (10);
   ELSE
      content1 := content1 || 'SET WIMAX_LABEL1=N' || CHR (13) || CHR (10);
   END IF;
--END Get Wimax&Wlan Info

EXCEPTION
   WHEN OTHERS
   THEN
      o_status := 'FAIL';
      o_msg := o_msg || 'Error code :' || SQLCODE || ', Message :';
      o_msg := o_msg || SUBSTR (SQLERRM, 1, 200) || CHR (13) || CHR (10);
END;

CREATE OR REPLACE PROCEDURE sfis1.c_getbom_gps (q_sn       IN     VARCHAR2,
                                                o_status      OUT VARCHAR2,
                                                o_msg         OUT VARCHAR2,
                                                content1      OUT VARCHAR2)
AS
   c_count NUMBER;
   q_qps VARCHAR2 (30);
BEGIN
   content1 := NULL;
   --GET GPS INFO
   sfis1.c_getbom_read_spec1 (q_sn, 'BT', 'SPEC2', q_qps, o_status, o_msg);

   IF q_qps IS NULL
   THEN
      content1 := content1 || 'SET GPS=EMPTY' || CHR (13) || CHR (10);
   ELSE
      content1 := content1 || 'SET GPS=' || q_qps || CHR (13) || CHR (10);
   END IF;
--END GET GPS INFO
EXCEPTION
   WHEN OTHERS
   THEN
      o_status := 'FAIL';
      o_msg := o_msg || 'Error code :' || SQLCODE || ', Message :';
      o_msg := o_msg || SUBSTR (SQLERRM, 1, 200) || CHR (13) || CHR (10);
END;

CREATE OR REPLACE PROCEDURE sfis1.c_getbom_iob (q_sn       IN     VARCHAR2,
                                                o_status      OUT VARCHAR2,
                                                o_msg         OUT VARCHAR2,
                                                content1      OUT VARCHAR2)
AS
   c_count NUMBER;
   q_iobdesc VARCHAR2 (30);
BEGIN
   content1 := NULL;
   ---IO/B DESC
   sfis1.c_getbom_read_spec1 (q_sn, 'IO/B', 'KP_DESC', q_iobdesc, o_status, o_msg);

   IF q_iobdesc IS NULL
   THEN
      content1 := content1 || 'SET IO/B_DESC=EMPTY' || CHR (13) || CHR (10);
   ELSE
      content1 := content1 || 'SET IO/B_DESC=' || q_iobdesc || CHR (13) || CHR (10);
   END IF;
---END IO/B DESC
EXCEPTION
   WHEN OTHERS
   THEN
      o_status := 'FAIL';
      o_msg := o_msg || 'Error code :' || SQLCODE || ', Message :';
      o_msg := o_msg || SUBSTR (SQLERRM, 1, 200) || CHR (13) || CHR (10);
END;

CREATE OR REPLACE PROCEDURE sfis1.c_getbom_modem (q_sn       IN     VARCHAR2,
                                                  o_status      OUT VARCHAR2,
                                                  o_msg         OUT VARCHAR2,
                                                  content1      OUT VARCHAR2)
AS
   c_count NUMBER;
   q_modem VARCHAR2 (30);
BEGIN
   content1 := NULL;
   --GET MODEM INFO
   sfis1.c_getbom_read_spec1 (q_sn, 'MODEM', 'SPEC2', q_modem, o_status, o_msg);

   IF q_modem IS NULL
   THEN
      content1 := content1 || 'SET MODEM=EMPTY' || CHR (13) || CHR (10);
   ELSE
      content1 := content1 || 'SET MODEM=' || q_modem || CHR (13) || CHR (10);
   END IF;
--END GET MODEM INFO
EXCEPTION
   WHEN OTHERS
   THEN
      o_status := 'FAIL';
      o_msg := o_msg || 'Error code :' || SQLCODE || ', Message :';
      o_msg := o_msg || SUBSTR (SQLERRM, 1, 200) || CHR (13) || CHR (10);
END;

CREATE OR REPLACE PROCEDURE sfis1.c_getbom_express_card (q_sn       IN     VARCHAR2,
                                                         o_status      OUT VARCHAR2,
                                                         o_msg         OUT VARCHAR2,
                                                         content1      OUT VARCHAR2)
AS
   c_count NUMBER;
   q_express VARCHAR2 (30);
BEGIN
   content1 := NULL;
   --GET EXPRESS_CARD INFO
   sfis1.c_getbom_read_spec1 (q_sn, 'EXPRESS CARD', 'SPEC2', q_express, o_status, o_msg);

   IF q_express IS NULL
   THEN
      content1 := content1 || 'SET EXPRESS_CARD=EMPTY' || CHR (13) || CHR (10);
   ELSE
      content1 := content1 || 'SET EXPRESS_CARD=' || q_express || CHR (13) || CHR (10);
   END IF;
--END GET EXPRESS_CARD INFO
EXCEPTION
   WHEN OTHERS
   THEN
      o_status := 'FAIL';
      o_msg := o_msg || 'Error code :' || SQLCODE || ', Message :';
      o_msg := o_msg || SUBSTR (SQLERRM, 1, 200) || CHR (13) || CHR (10);
END;

CREATE OR REPLACE PROCEDURE sfis1.c_getbom_tvt (q_sn       IN     VARCHAR2,
                                                o_status      OUT VARCHAR2,
                                                o_msg         OUT VARCHAR2,
                                                content1      OUT VARCHAR2)
AS
   c_count NUMBER;
   q_tvt VARCHAR2 (30);
BEGIN
   content1 := NULL;
   --GET TVT INFO
   sfis1.c_getbom_read_spec1 (q_sn, 'TV/T', 'SPEC2', q_tvt, o_status, o_msg);

   IF q_tvt IS NULL
   THEN
      content1 := content1 || 'SET TVT=EMPTY' || CHR (13) || CHR (10);
   ELSE
      content1 := content1 || 'SET TVT=' || q_tvt || CHR (13) || CHR (10);
   END IF;
--END GET TVT INFO
EXCEPTION
   WHEN OTHERS
   THEN
      o_status := 'FAIL';
      o_msg := o_msg || 'Error code :' || SQLCODE || ', Message :';
      o_msg := o_msg || SUBSTR (SQLERRM, 1, 200) || CHR (13) || CHR (10);
END;

CREATE OR REPLACE PROCEDURE sfis1.c_getbom_amt (q_sn       IN     VARCHAR2,
                                                o_status      OUT VARCHAR2,
                                                o_msg         OUT VARCHAR2,
                                                content1      OUT VARCHAR2)
AS
   c_count NUMBER;
   q_amt VARCHAR2 (30);
BEGIN
   content1 := NULL;

   --GET AMT INFO 20230414 Aaronl_lin
   SELECT COUNT (b.spec1)
     INTO c_count
     FROM sfism4.r_wip_tracking_t a, sfis1.c_keyparts_desc_t b, sfis1.c_bom_keypart_t bk
    WHERE     a.bom_no = bk.bom_no
          AND bk.key_part_no = b.key_part_no
          AND SUBSTR (b.TYPE, 1, 3) = 'AMT'
          AND a.serial_number = q_sn;

   IF c_count > 0
   THEN
      SELECT b.spec1
        INTO q_amt
        FROM sfism4.r_wip_tracking_t a, sfis1.c_keyparts_desc_t b, sfis1.c_bom_keypart_t bk
       WHERE     a.bom_no = bk.bom_no
             AND bk.key_part_no = b.key_part_no
             AND SUBSTR (b.TYPE, 1, 3) = 'AMT'
             AND a.serial_number = q_sn
             AND ROWNUM = 1;

      content1 := content1 || 'SET AMT=' || q_amt || CHR (13) || CHR (10);
   ELSE
      content1 := content1 || 'SET AMT=EMPTY' || CHR (13) || CHR (10);
   END IF;
--END GET AMT INFO
EXCEPTION
   WHEN OTHERS
   THEN
      o_status := 'FAIL';
      o_msg := o_msg || 'Error code :' || SQLCODE || ', Message :';
      o_msg := o_msg || SUBSTR (SQLERRM, 1, 200) || CHR (13) || CHR (10);
END;



CREATE OR REPLACE PROCEDURE sfis1.c_getbom_TOUCHSC (q_sn       IN     VARCHAR2,
                                                 o_status      OUT VARCHAR2,
                                                 o_msg         OUT VARCHAR2,
                                                 content1      OUT VARCHAR2)
AS
   c_count NUMBER;
   q_touchsc VARCHAR2 (30);
BEGIN
   content1 := NULL;
      --GET TOUCHSC INFO
   SELECT COUNT (*)
     INTO c_count
     FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
    WHERE     a.key_part_no = b.key_part_no
          AND b.TYPE = 'TOUCHSC'
          AND a.serial_number = q_sn;

   IF c_count > 0
   THEN
      SELECT b.spec2
        INTO q_touchsc
        FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
       WHERE     a.key_part_no = b.key_part_no
             AND b.TYPE = 'TOUCHSC'
             AND a.serial_number = q_sn
             AND ROWNUM = 1;
   ELSE
      IF q_lcdsn IS NULL
      THEN
         SELECT COUNT (*)
           INTO c_count
           FROM sfism4.r_wip_keyparts_t b, sfis1.c_keyparts_desc_t a
          WHERE     a.key_part_no = b.key_part_no
                AND a.TYPE = 'LCD'
                AND LENGTH (b.key_part_sn) = 13
                AND b.serial_number = q_sn;

         IF c_count > 0
         THEN
            SELECT b.key_part_sn
              INTO q_lcdsn
              FROM sfism4.r_wip_keyparts_t b, sfis1.c_keyparts_desc_t a
             WHERE     a.key_part_no = b.key_part_no
                   AND a.TYPE = 'LCD'
                   AND LENGTH (b.key_part_sn) = 13
                   AND b.serial_number = q_sn
                   AND ROWNUM = 1;
         END IF;
      END IF;

      IF q_lcdsn IS NULL
      THEN
         SELECT COUNT (*)
           INTO c_count
           FROM sfism4.r_wip_keyparts_t b, sfis1.c_keyparts_desc_t a
          WHERE     a.key_part_no = b.key_part_no
                AND a.TYPE = 'LCD PANEL'
                AND LENGTH (b.key_part_sn) = 13
                AND b.serial_number = q_sn;

         IF c_count > 0
         THEN
            SELECT b.key_part_sn
              INTO q_lcdsn
              FROM sfism4.r_wip_keyparts_t b, sfis1.c_keyparts_desc_t a
             WHERE     a.key_part_no = b.key_part_no
                   AND a.TYPE = 'LCD PANEL'
                   AND LENGTH (b.key_part_sn) = 13
                   AND b.serial_number = q_sn
                   AND ROWNUM = 1;
         END IF;
      END IF;

      IF q_lcdsn IS NULL
      THEN
         ---Get Type=LCD PANEL SFISM4.R_WIP_KEYPARTS_T SERIAL_NUMBER Value 20210715
         ---One 51#SN 20210715
         SELECT COUNT (d.key_part_no)
           INTO c_count
           FROM sfis1.c_keyparts_desc_t d, sfism4.r_wip_keyparts_t k,
                sfism4.r_wip_keyparts_t k2
          WHERE     LENGTH (k.key_part_sn) = 13
                AND k2.serial_number = k.key_part_sn
                AND d.key_part_no = k2.key_part_no
                AND d.TYPE = 'LCD PANEL'
                AND k.serial_number = q_sn
                AND ROWNUM = 1;

         IF c_count > 0
         THEN
            SELECT k2.serial_number
              INTO q_lcdsn
              FROM sfis1.c_keyparts_desc_t d, sfism4.r_wip_keyparts_t k,
                   sfism4.r_wip_keyparts_t k2
             WHERE     LENGTH (k.key_part_sn) = 13
                   AND k2.serial_number = k.key_part_sn
                   AND d.key_part_no = k2.key_part_no
                   AND d.TYPE = 'LCD PANEL'
                   AND k.serial_number = q_sn
                   AND ROWNUM = 1;
         END IF;

         IF c_count = 0
         THEN
            ---Two 51#SN 20210715
            SELECT COUNT (d.key_part_no)
              INTO c_count
              FROM sfis1.c_keyparts_desc_t d, sfism4.r_wip_keyparts_t k,
                   sfism4.r_wip_keyparts_t k2, sfism4.r_wip_keyparts_t k3
             WHERE     LENGTH (k.key_part_sn) = 13
                   AND k2.serial_number = k.key_part_sn
                   AND LENGTH (k2.key_part_sn) = 13
                   AND k3.serial_number = k2.key_part_sn
                   AND d.key_part_no = k3.key_part_no
                   AND d.TYPE = 'LCD PANEL'
                   AND k.serial_number = q_sn
                   AND ROWNUM = 1;

            IF c_count > 0
            THEN
               SELECT k3.serial_number
                 INTO q_lcdsn
                 FROM sfis1.c_keyparts_desc_t d, sfism4.r_wip_keyparts_t k,
                      sfism4.r_wip_keyparts_t k2, sfism4.r_wip_keyparts_t k3
                WHERE     LENGTH (k.key_part_sn) = 13
                      AND k2.serial_number = k.key_part_sn
                      AND LENGTH (k2.key_part_sn) = 13
                      AND k3.serial_number = k2.key_part_sn
                      AND d.key_part_no = k3.key_part_no
                      AND d.TYPE = 'LCD PANEL'
                      AND k.serial_number = q_sn
                      AND ROWNUM = 1;
            END IF;

            IF c_count = 0
            THEN
               ---There 51#SN 20210715
               SELECT COUNT (d.key_part_no)
                 INTO c_count
                 FROM sfis1.c_keyparts_desc_t d, sfism4.r_wip_keyparts_t k,
                      sfism4.r_wip_keyparts_t k2, sfism4.r_wip_keyparts_t k3,
                      sfism4.r_wip_keyparts_t k4
                WHERE     LENGTH (k.key_part_sn) = 13
                      AND k2.serial_number = k.key_part_sn
                      AND LENGTH (k2.key_part_sn) = 13
                      AND k3.serial_number = k2.key_part_sn
                      AND LENGTH (k3.key_part_sn) = 13
                      AND k4.serial_number = k3.key_part_sn
                      AND d.key_part_no = k4.key_part_no
                      AND d.TYPE = 'LCD PANEL'
                      AND k.serial_number = q_sn
                      AND ROWNUM = 1;

               IF c_count > 0
               THEN
                  SELECT k4.serial_number
                    INTO q_lcdsn
                    FROM sfis1.c_keyparts_desc_t d, sfism4.r_wip_keyparts_t k,
                         sfism4.r_wip_keyparts_t k2,
                         sfism4.r_wip_keyparts_t k3,
                         sfism4.r_wip_keyparts_t k4
                   WHERE     LENGTH (k.key_part_sn) = 13
                         AND k2.serial_number = k.key_part_sn
                         AND LENGTH (k2.key_part_sn) = 13
                         AND k3.serial_number = k2.key_part_sn
                         AND LENGTH (k3.key_part_sn) = 13
                         AND k4.serial_number = k3.key_part_sn
                         AND d.key_part_no = k4.key_part_no
                         AND d.TYPE = 'LCD PANEL'
                         AND k.serial_number = q_sn
                         AND ROWNUM = 1;
               END IF;
            END IF;
         END IF;
      END IF;

      IF q_lcdsn IS NOT NULL
      THEN
         SELECT COUNT (*)
           INTO c_count
           FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
          WHERE     a.key_part_no = b.key_part_no
                AND b.TYPE = 'TOUCHSC'
                AND a.serial_number = q_lcdsn;

         IF c_count > 0
         THEN
            SELECT b.spec2
              INTO q_touchsc
              FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
             WHERE     a.key_part_no = b.key_part_no
                   AND b.TYPE = 'TOUCHSC'
                   AND a.serial_number = q_lcdsn
                   AND ROWNUM = 1;
         ELSE
            SELECT COUNT (*)
              INTO c_count
              FROM sfism4.r_wip_keyparts_t k2, sfism4.r_wip_keyparts_t k,
                   sfis1.c_keyparts_desc_t d, sfis1.c_keyparts_desc_t d2
             WHERE     k.key_part_no = d.key_part_no
                   AND k2.serial_number = k.key_part_sn
                   AND k2.key_part_no = d2.key_part_no
                   AND d.TYPE = 'T/S ASSY'
                   AND d2.TYPE = 'TOUCHSC'
                   AND k.serial_number = q_lcdsn;

            IF c_count > 0
            THEN
               SELECT d2.spec2
                 INTO q_touchsc
                 FROM sfism4.r_wip_keyparts_t k2, sfism4.r_wip_keyparts_t k,
                      sfis1.c_keyparts_desc_t d, sfis1.c_keyparts_desc_t d2
                WHERE     k.key_part_no = d.key_part_no
                      AND k2.serial_number = k.key_part_sn
                      AND k2.key_part_no = d2.key_part_no
                      AND d.TYPE = 'T/S ASSY'
                      AND d2.TYPE = 'TOUCHSC'
                      AND k.serial_number = q_lcdsn
                      AND ROWNUM = 1;
            ELSE
               SELECT COUNT (*)
                 INTO c_count
                 FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
                WHERE     a.key_part_no = b.key_part_no
                      AND b.TYPE = 'LCD PANEL'
                      AND a.serial_number = q_lcdsn;

               IF c_count > 0
               THEN
                  SELECT b.spec3
                    INTO q_touchsc
                    FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
                   WHERE     a.key_part_no = b.key_part_no
                         AND b.TYPE = 'LCD PANEL'
                         AND a.serial_number = q_lcdsn
                         AND ROWNUM = 1;
               ELSE
                  SELECT COUNT (*)
                    INTO c_count
                    FROM sfism4.r_wip_keyparts_t k2,
                         sfism4.r_wip_keyparts_t k, sfis1.c_keyparts_desc_t d,
                         sfis1.c_keyparts_desc_t d2
                   WHERE     k.key_part_no = d.key_part_no
                         AND k2.serial_number = k.key_part_sn
                         AND k2.key_part_no = d2.key_part_no
                         AND d.TYPE = 'T/S ASSY'
                         AND d2.TYPE = 'LCD PANEL'
                         AND k.serial_number = q_lcdsn;

                  IF c_count > 0
                  THEN
                     SELECT d2.spec3
                       INTO q_touchsc
                       FROM sfism4.r_wip_keyparts_t k2,
                            sfism4.r_wip_keyparts_t k,
                            sfis1.c_keyparts_desc_t d,
                            sfis1.c_keyparts_desc_t d2
                      WHERE     k.key_part_no = d.key_part_no
                            AND k2.serial_number = k.key_part_sn
                            AND k2.key_part_no = d2.key_part_no
                            AND d.TYPE = 'T/S ASSY'
                            AND d2.TYPE = 'LCD PANEL'
                            AND k.serial_number = q_lcdsn
                            AND ROWNUM = 1;
                  ELSE
                     SELECT COUNT (*)
                       INTO c_count
                       FROM sfism4.r_wip_keyparts_t wk,
                            sfism4.r_wip_keyparts_t kk,
                            sfis1.c_keyparts_desc_t kd
                      WHERE     wk.key_part_sn = kk.serial_number
                            AND kk.key_part_no = kd.key_part_no
                            AND kd.TYPE = 'LCD PANEL'
                            AND wk.serial_number = q_lcdsn;

                     IF c_count > 0
                     THEN
                        SELECT kd.spec3
                          INTO q_touchsc
                          FROM sfism4.r_wip_keyparts_t wk,
                               sfism4.r_wip_keyparts_t kk,
                               sfis1.c_keyparts_desc_t kd
                         WHERE     wk.key_part_sn = kk.serial_number
                               AND kk.key_part_no = kd.key_part_no
                               AND kd.TYPE = 'LCD PANEL'
                               AND wk.serial_number = q_lcdsn
                               AND ROWNUM = 1;
                     END IF;
                  END IF;
               END IF;
            END IF;
         END IF;
      ELSE
         SELECT COUNT (*)
           INTO c_count
           FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
          WHERE     a.key_part_no = b.key_part_no
                AND b.TYPE = 'LCD PANEL'
                AND a.serial_number = q_sn;

         IF c_count > 0
         THEN
            SELECT b.spec3
              INTO q_touchsc
              FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
             WHERE     a.key_part_no = b.key_part_no
                   AND b.TYPE = 'LCD PANEL'
                   AND a.serial_number = q_sn
                   AND ROWNUM = 1;
         END IF;

         IF q_touchsc IS NULL
         THEN
            SELECT COUNT (*)
              INTO c_count
              FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
             WHERE     a.key_part_no = b.key_part_no
                   AND b.TYPE = 'LCD'
                   AND a.serial_number = q_sn;

            IF c_count > 0
            THEN
               SELECT b.spec4
                 INTO q_touchsc
                 FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
                WHERE     a.key_part_no = b.key_part_no
                      AND b.TYPE = 'LCD'
                      AND a.serial_number = q_sn
                      AND ROWNUM = 1;
            END IF;
         END IF;
      END IF;
   END IF;

   IF q_touchsc IS NULL
   THEN
      SELECT COUNT (*)
        INTO c_count
        FROM sfis1.c_part_control_t ct, sfism4.r_wip_keyparts_t kt
       WHERE     ct.key_part_no = kt.key_part_no
             AND ct.cust_no = 'A31'
             AND ct.cust_part_no = 'SWDL'
             AND ct.part_type = 'E_TP'
             AND kt.serial_number =
                    (SELECT b.key_part_sn
                       FROM sfism4.r_wip_keyparts_t b,
                            sfis1.c_keyparts_desc_t a
                      WHERE     a.key_part_no = b.key_part_no
                            AND a.TYPE = 'LCD'
                            AND LENGTH (b.key_part_sn) = 13
                            AND b.serial_number = q_sn
                            AND ROWNUM = 1);

      IF c_count > 0
      THEN
         q_touchsc := 'EXIST';
      ELSE
         q_touchsc := 'EMPTY';
      END IF;
   END IF;

   IF (q_touchsc = 'EMPTY')
   THEN
      --- Get 2D$T6%51#SN $ULCD PANEL SPEC3
      IF (panel_sepc3 IS NOT NULL)
      THEN
         q_touchsc := panel_sepc3;
      END IF;
   END IF;

   content1 := content1 || 'SET TOUCHSC=' || q_touchsc || CHR (13) || CHR (10);

   --END GET TOUCHSC INFO
EXCEPTION
   WHEN OTHERS
   THEN
      o_status := 'FAIL';
      o_msg := o_msg || 'Error code :' || SQLCODE || ', Message :';
      o_msg := o_msg || SUBSTR (SQLERRM, 1, 200) || CHR (13) || CHR (10);
END;

CREATE OR REPLACE PROCEDURE sfis1.c_getbom_xxxx (q_sn       IN     VARCHAR2,
                                                 o_status      OUT VARCHAR2,
                                                 o_msg         OUT VARCHAR2,
                                                 content1      OUT VARCHAR2)
AS
   c_count NUMBER;
   q_fprint VARCHAR2 (30);
BEGIN
   content1 := NULL;
EXCEPTION
   WHEN OTHERS
   THEN
      o_status := 'FAIL';
      o_msg := o_msg || 'Error code :' || SQLCODE || ', Message :';
      o_msg := o_msg || SUBSTR (SQLERRM, 1, 200) || CHR (13) || CHR (10);
END;