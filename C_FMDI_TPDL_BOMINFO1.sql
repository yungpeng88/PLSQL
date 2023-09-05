/* Formatted on 2023/8/29 上午 09:05:01 (QP5 v5.256.13226.35538) */
CREATE OR REPLACE PROCEDURE c_fmdi_tpdl_bominfo1 (
   i_sn         IN     VARCHAR2,
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
   q_custpn VARCHAR2 (30);
   q_cpn VARCHAR2 (30);
   q_model VARCHAR2 (30);
   q_swidnum VARCHAR2 (30);
   q_servtag VARCHAR2 (30);
   q_mb46l VARCHAR2 (30);
   q_mbsn VARCHAR2 (30);
   q_mbbtmac VARCHAR2 (30);
   q_mbwlanmac VARCHAR2 (30);
   q_dbmac VARCHAR2 (30);
   q_db1394 VARCHAR2 (30);
   q_uuid VARCHAR2 (30);
   q_lcdsn VARCHAR2 (30);
   q_lcdspec2 VARCHAR2 (30);
   q_ramspec2 VARCHAR2 (30);
   q_ramspec3 VARCHAR2 (30);
   q_ramspec6 VARCHAR2 (30);
   q_hddspec1 VARCHAR2 (30);
   q_hddspec2 VARCHAR2 (30);
   q_panelspec1 VARCHAR2 (30);
   q_panelspec2 VARCHAR2 (30);
   q_hddflag VARCHAR2 (30);
   q_cpuspec2 VARCHAR2 (30);
   q_cpuspec3 VARCHAR2 (30);
   q_wlan1spec1 VARCHAR2 (30);
   q_wlan1spec2 VARCHAR2 (30);
   q_wlan2spec1 VARCHAR2 (30);
   q_wlan2spec2 VARCHAR2 (30);
   q_iobwlan VARCHAR2 (30);
   q_iobdesc VARCHAR2 (150);
   q_camera VARCHAR2 (30);
   q_cameraid VARCHAR2 (50);
   q_dw_ax VARCHAR2 (30);
   q_camidx VARCHAR2 (30);
   q_batt VARCHAR2 (30);
   q_batt1 VARCHAR2 (30);
   q_odd VARCHAR2 (30);
   q_fprint VARCHAR2 (30);
   q_rfid VARCHAR2 (30);
   q_color VARCHAR2 (30);
   q_blue VARCHAR2 (30);
   q_mic VARCHAR2 (30);
   q_qps VARCHAR2 (30);
   q_modem VARCHAR2 (30);
   q_nfc VARCHAR2 (30);
   q_smart VARCHAR2 (30);
   q_express VARCHAR2 (30);
   q_kb VARCHAR2 (30);
   q_kbbl VARCHAR2 (30);
   q_button VARCHAR2 (30);
   q_tvt VARCHAR2 (30);
   q_amt VARCHAR2 (30);
   q_touchsc VARCHAR2 (30);
   q_mhdd NUMBER;
   q_sn VARCHAR2 (30);
   c_count NUMBER;
   c_ram NUMBER;
   c_hdd NUMBER;
   c_cam NUMBER;
   c_equipment NUMBER;
   q_equipment VARCHAR2 (150);
   q_hddvero VARCHAR2 (30);
   q_hddvern VARCHAR2 (30);
   q_project VARCHAR2 (30);
   q_wwan VARCHAR2 (30);
   q_wwan_imei VARCHAR2 (30);
   q_wwan_kps VARCHAR2 (30);
   q_mbspec6 VARCHAR2 (30);
   q_date VARCHAR2 (30);
   q_intel_nfc VARCHAR2 (30);
   q_region VARCHAR2 (30);
   q_iccid VARCHAR2 (45);
   q_vgatp VARCHAR2 (30);
   q_vgasz VARCHAR2 (30);
   q_pr_cable VARCHAR2 (30);
   q_dw_cable VARCHAR2 (30);
   q_edp_cable VARCHAR2 (30);
   q_line_name VARCHAR2 (30);
   q_psensor VARCHAR2 (30);
   q_molevel VARCHAR2 (30);
   q_hdd_kpn VARCHAR2 (11);
   q_hdd_kpdesc VARCHAR2 (150);
   q_hdd_kps VARCHAR2 (45);
   q_hdd_kpr VARCHAR2 (30);
   q_bootdpn VARCHAR2 (30);
   q_bootkpr VARCHAR2 (30);
   q_ramspec4 VARCHAR2 (30);
   q_hdd_image VARCHAR2 (150);
   q_lan_b VARCHAR2 (30);
   q_kbcode VARCHAR2 (30);
   q_tpfw1 VARCHAR2 (30);
   q_tpfw2 VARCHAR2 (30);
   q_tpbl1 VARCHAR2 (30);
   q_hinge VARCHAR2 (100);
   q_realtime VARCHAR2 (20);
   q_edp_ish VARCHAR2 (20);
   q_vram VARCHAR2 (50);
   q_mbtype VARCHAR2 (150);
   q_kbpn VARCHAR2 (20);
   q_kpn VARCHAR2 (20);
   q_spec4 VARCHAR2 (30);
   q_edp_desc VARCHAR2 (150);
   q_l10antenna VARCHAR2 (150);
   q_51antenna VARCHAR2 (150);
   c_l10antenna NUMBER;
   c_51antenna NUMBER;
   q_eppid VARCHAR2 (25);
   panel_sepc3 VARCHAR2 (30);
   q_model_desc3 VARCHAR2 (100);
   q_model_desc4 VARCHAR2 (100);
   q_mhdd_sqty NUMBER;
   q_touchpad VARCHAR2 (20);
   q_logicupper VARCHAR2 (20);
   q_keembay VARCHAR2 (100);
   q_order_type VARCHAR2 (20);
   q_ram VARCHAR2 (100);
   q_wlan_rf VARCHAR2 (100);
   q_wwan_rf VARCHAR2 (100);
   q_rugged_ptb VARCHAR2 (100);
   q_rugged_psensor VARCHAR2 (100);
   q_lcd_bezel_desc VARCHAR2 (100);
   q_mic_desc VARCHAR2 (100);
   q_rugged_lan VARCHAR2 (100);
   q_rugged_scanner VARCHAR2 (100);
   q_rugged_fischr VARCHAR2 (100);
   q_rugged_rs232 VARCHAR2 (100);
   q_rugged_cameraf VARCHAR2 (100);
   q_rugged_camerbf VARCHAR2 (100);
   q_rugged_ush VARCHAR2 (100);
   q_rugged_nfc VARCHAR2 (100);
   q_rugged_fprint VARCHAR2 (100);
   q_rugged_smart VARCHAR2 (100);
   q_rugged_hdmi VARCHAR2 (100);
   q_rugged_usbio VARCHAR2 (100);
   q_rugged_2ndbattery VARCHAR2 (100);
   q_strbasesn VARCHAR2 (100);
   q_wlan_ant VARCHAR2 (100);
   q_wwan_ant VARCHAR2 (100);
   q_dphilica VARCHAR2 (100);
   q_secondmac VARCHAR2 (100);
   q_dbos VARCHAR2 (100);
   q_wlbt VARCHAR2 (100);
   q_onboardmbqty NUMBER;
   q_onboardspec VARCHAR2 (100);
BEGIN


  

   --Get OnboardQty Eddie_Ho Add @20230426
   SELECT COUNT (ckd.key_part_no)
     INTO q_onboardmbqty
     FROM sfis1.c_keyparts_def_t ckd
    WHERE ckd.key_part_no = q_mb46l;

   --End Get OnboardQty




   --GET WLAN Darwin3.0
   SELECT COUNT (*)
     INTO c_count
     FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
    WHERE     a.key_part_no = b.key_part_no
          AND b.TYPE = 'ANTENNA'
          AND b.spec4 IS NOT NULL
          AND a.serial_number = q_sn;

   IF c_count > 0
   THEN
      SELECT b.spec4
        INTO q_spec4
        FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
       WHERE     a.key_part_no = b.key_part_no
             AND b.TYPE = 'ANTENNA'
             AND b.spec4 IS NOT NULL
             AND a.serial_number = q_sn
             AND ROWNUM = 1;

      content1 :=
         content1 || 'SET WLAN Darwin3.0=' || q_spec4 || CHR (13) || CHR (10);
   END IF;

   --END WLAN Darwin3.0

   --GET MCU/B
   SELECT COUNT (*)
     INTO c_count
     FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
    WHERE     a.key_part_no = b.key_part_no
          AND b.TYPE = 'MCU/B'
          AND a.serial_number = q_sn;

   IF c_count > 0
   THEN
      SELECT b.key_part_no
        INTO q_kpn
        FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
       WHERE     a.key_part_no = b.key_part_no
             AND b.TYPE = 'MCU/B'
             AND a.serial_number = q_sn
             AND ROWNUM = 1;

      content1 := content1 || 'SET MCU/B=' || q_kpn || CHR (13) || CHR (10);
   END IF;

   --END MCU/B

   --Get ANTENNA Desc.
   c_l10antenna := 0;
   c_51antenna := 0;

   SELECT COUNT (b.serial_number)
     INTO c_count
     FROM sfism4.r_wip_keyparts_t b, sfis1.c_keyparts_desc_t a,
          sfism4.r_wip_tracking_t w
    WHERE     b.serial_number = w.serial_number
          AND a.key_part_no = b.key_part_no
          AND w.serial_number = q_sn
          AND a.TYPE = 'ANTENNA';

   IF (c_count > 0)
   THEN
      DECLARE
         CURSOR antenna_curr
         IS
            SELECT kd.kp_desc
              FROM sfism4.r_wip_keyparts_t wk, sfis1.c_keyparts_desc_t kd
             WHERE     wk.key_part_no = kd.key_part_no
                   AND kd.TYPE = 'ANTENNA'
                   AND wk.serial_number = q_sn;

         antenna_recr antenna_curr%ROWTYPE;
      BEGIN
         FOR antenna_recr IN antenna_curr
         LOOP
            q_l10antenna := antenna_recr.kp_desc;
            c_l10antenna := c_l10antenna + 1;
            content2 :=
                  content2
               || 'SET L10ANTENNA'
               || TO_CHAR (c_l10antenna)
               || '='
               || q_l10antenna
               || CHR (13)
               || CHR (10);
         END LOOP;
      END;

      IF (c_l10antenna = 1)
      THEN
         content2 :=
               content2
            || 'SET L10ANTENNA2'
            || '='
            || 'EMPTY'
            || CHR (13)
            || CHR (10);
      END IF;
   ELSE
      content2 :=
            content2
         || 'SET L10ANTENNA1'
         || '='
         || 'EMPTY'
         || CHR (13)
         || CHR (10);
      content2 :=
            content2
         || 'SET L10ANTENNA2'
         || '='
         || 'EMPTY'
         || CHR (13)
         || CHR (10);
   END IF;

   SELECT COUNT (b.serial_number)
     INTO c_count
     FROM sfism4.r_wip_keyparts_t b, sfis1.c_keyparts_desc_t a,
          sfism4.r_wip_tracking_t w
    WHERE     b.serial_number = w.serial_number
          AND a.key_part_no = b.key_part_no
          AND w.serial_number = q_sn
          AND a.TYPE = 'LCD';

   IF (c_count > 0)
   THEN
      SELECT b.key_part_sn
        INTO q_strbasesn
        FROM sfism4.r_wip_keyparts_t b, sfis1.c_keyparts_desc_t a,
             sfism4.r_wip_tracking_t w
       WHERE     b.serial_number = w.serial_number
             AND a.key_part_no = b.key_part_no
             AND w.serial_number = q_sn
             AND a.TYPE = 'LCD'
             AND ROWNUM = 1;

      SELECT COUNT (b.key_part_sn)
        INTO c_count
        FROM sfism4.r_wip_keyparts_t b, sfis1.c_keyparts_desc_t a,
             sfism4.r_wip_tracking_t w
       WHERE     b.serial_number = w.serial_number
             AND a.key_part_no = b.key_part_no
             AND w.serial_number = q_strbasesn
             AND a.TYPE = 'ANTENNA';

      IF (c_count > 0)
      THEN
         DECLARE
            CURSOR antenna_cur
            IS
               SELECT dd.kp_desc
                 FROM sfism4.r_wip_keyparts_t wk, sfis1.c_keyparts_desc_t kd,
                      sfism4.r_wip_keyparts_t kk, sfis1.c_keyparts_desc_t dd
                WHERE     wk.key_part_no = kd.key_part_no
                      AND wk.key_part_sn = kk.serial_number
                      AND kk.key_part_no = dd.key_part_no
                      AND kd.TYPE = 'LCD'
                      AND dd.TYPE = 'ANTENNA'
                      AND wk.serial_number = q_sn
               UNION ALL
               SELECT dd.kp_desc
                 FROM sfism4.r_wip_keyparts_t wk, sfis1.c_keyparts_desc_t kd,
                      sfism4.r_wip_keyparts_t kk, sfis1.c_keyparts_desc_t dd,
                      sfism4.r_wip_keyparts_t kkk
                WHERE     wk.key_part_no = kd.key_part_no
                      AND wk.key_part_sn = kk.serial_number
                      AND kk.key_part_sn = kkk.serial_number
                      AND kkk.key_part_no = dd.key_part_no
                      AND kd.TYPE = 'LCD'
                      AND dd.TYPE = 'ANTENNA'
                      AND wk.serial_number = q_sn;

            antenna_rec antenna_cur%ROWTYPE;
         BEGIN
            FOR antenna_rec IN antenna_cur
            LOOP
               q_51antenna := antenna_rec.kp_desc;
               c_51antenna := c_51antenna + 1;
               content2 :=
                     content2
                  || 'SET 51ANTENNA'
                  || TO_CHAR (c_51antenna)
                  || '='
                  || q_51antenna
                  || CHR (13)
                  || CHR (10);
            END LOOP;
         END;

         IF (c_51antenna = 1)
         THEN
            content2 :=
                  content2
               || 'SET 51ANTENNA2'
               || '='
               || 'EMPTY'
               || CHR (13)
               || CHR (10);
         END IF;
      ELSE
         content2 :=
               content2
            || 'SET 51ANTENNA1'
            || '='
            || 'EMPTY'
            || CHR (13)
            || CHR (10);
         content2 :=
               content2
            || 'SET 51ANTENNA2'
            || '='
            || 'EMPTY'
            || CHR (13)
            || CHR (10);
      END IF;
   ELSE
      content2 :=
            content2
         || 'SET 51ANTENNA1'
         || '='
         || 'EMPTY'
         || CHR (13)
         || CHR (10);
      content2 :=
            content2
         || 'SET 51ANTENNA2'
         || '='
         || 'EMPTY'
         || CHR (13)
         || CHR (10);
   END IF;

   --END Get ANTENNA Desc.

   --GET EPPID
   SELECT COUNT (wk.key_part_sn)
     INTO c_count
     FROM sfism4.r_wip_keyparts_t wk
    WHERE wk.kp_relation = '99' AND wk.serial_number = q_sn;

   IF c_count > 0
   THEN
      SELECT wk.key_part_sn || wk.version
        INTO q_eppid
        FROM sfism4.r_wip_keyparts_t wk
       WHERE wk.kp_relation = '99' AND wk.serial_number = q_sn;
   ELSE
      q_eppid := '';
   END IF;

   content2 := content2 || 'SET EPPID=' || q_eppid || CHR (13) || CHR (10);

   --END EPPID

   --GET USH/B
   SELECT COUNT (*)
     INTO c_count
     FROM sfism4.r_wip_keyparts_t a, sfis1.c_keyparts_desc_t b
    WHERE     a.key_part_no = b.key_part_no
          AND b.TYPE = 'USH/B'
          AND a.serial_number = q_sn;

   IF c_count > 0
   THEN
      content2 := content2 || 'SET USH=EXIST' || CHR (13) || CHR (10);
   ELSE
      SELECT COUNT (*)
        INTO c_count
        FROM sfism4.r_wip_keyparts_t a, sfism4.r_wip_keyparts_t b,
             sfis1.c_keyparts_desc_t c
       WHERE     a.key_part_sn = b.serial_number
             AND b.key_part_no = c.key_part_no
             AND c.TYPE = 'USH/B'
             AND a.serial_number = q_sn;

      IF c_count > 0
      THEN
         content2 := content2 || 'SET USH=EXIST' || CHR (13) || CHR (10);
      ELSE
         content2 := content2 || 'SET USH=EMPTY' || CHR (13) || CHR (10);
      END IF;
   END IF;

   --END USH/B

   --GET TOUCH PAD
   SELECT COUNT (key_part_no)
     INTO c_count
     FROM (SELECT kd.key_part_no
             FROM sfism4.r_wip_keyparts_t wk, sfism4.r_wip_keyparts_t tt,
                  sfis1.c_keyparts_desc_t kd
            WHERE     wk.key_part_sn = tt.serial_number
                  AND tt.key_part_no = kd.key_part_no
                  AND kd.TYPE = 'TOUCH PAD'
                  AND wk.serial_number = q_sn
           UNION ALL
           SELECT kd.key_part_no
             FROM sfism4.r_wip_keyparts_t wk, sfis1.c_keyparts_desc_t kd
            WHERE     kd.key_part_no = wk.key_part_no
                  AND kd.TYPE = 'TOUCH PAD'
                  AND wk.serial_number = q_sn);

   IF c_count > 0
   THEN
      SELECT key_part_no
        INTO q_touchpad
        FROM (SELECT kd.key_part_no
                FROM sfism4.r_wip_keyparts_t wk, sfism4.r_wip_keyparts_t tt,
                     sfis1.c_keyparts_desc_t kd
               WHERE     wk.key_part_sn = tt.serial_number
                     AND tt.key_part_no = kd.key_part_no
                     AND kd.TYPE = 'TOUCH PAD'
                     AND wk.serial_number = q_sn
              UNION ALL
              SELECT kd.key_part_no
                FROM sfism4.r_wip_keyparts_t wk, sfis1.c_keyparts_desc_t kd
               WHERE     kd.key_part_no = wk.key_part_no
                     AND kd.TYPE = 'TOUCH PAD'
                     AND wk.serial_number = q_sn
                     AND ROWNUM = 1);

      content2 :=
         content2 || 'SET TOUCHPAD=' || q_touchpad || CHR (13) || CHR (10);
   ELSE
      content2 := content2 || 'SET TOUCHPAD=' || CHR (13) || CHR (10);
   END IF;

   --END TOUCH PAD

   ---GET SENSOR REQ:JHEN_KANG  2021/11/06
   SELECT COUNT (k.key_part_no)
     INTO c_count
     FROM sfism4.r_wip_keyparts_t k, sfis1.c_menu_parameter_t cmp
    WHERE     k.serial_number = q_sn
          AND k.key_part_no = cmp.item_key
          AND cmp.function_name = 'DARWIN_ANTENNA'
          AND cmp.cust_no = 'A31';

   IF c_count > 0
   THEN
      SELECT cmp.component_name
        INTO q_kpn
        FROM sfism4.r_wip_keyparts_t k, sfis1.c_menu_parameter_t cmp
       WHERE     k.serial_number = q_sn
             AND k.key_part_no = cmp.item_key
             AND cmp.function_name = 'DARWIN_ANTENNA'
             AND cmp.cust_no = 'A31'
             AND ROWNUM = 1;
   ELSE
      q_kpn := '';
   END IF;

   content2 := content2 || 'SET SENSOR=' || q_kpn || CHR (13) || CHR (10);

   --END SENSOR

   ---GET KEEMBAY
   SELECT COUNT (k.key_part_no)
     INTO c_count
     FROM sfism4.r_wip_keyparts_t k, sfis1.c_keyparts_desc_t d
    WHERE     k.key_part_no = d.key_part_no
          AND d.TYPE = 'KEEMBAY'
          AND k.serial_number = q_sn;

   IF c_count > 0
   THEN
      SELECT d.spec1
        INTO q_keembay
        FROM sfism4.r_wip_keyparts_t k, sfis1.c_keyparts_desc_t d
       WHERE     k.key_part_no = d.key_part_no
             AND d.TYPE = 'KEEMBAY'
             AND k.serial_number = q_sn
             AND ROWNUM = 1;
   ELSE
      q_keembay := '';
   END IF;

   content2 := content2 || 'SET KMB=' || q_keembay || CHR (13) || CHR (10);

   --END KEEMBAY

   ---GET LOGIC UPPER
   SELECT COUNT (k.key_part_no)
     INTO c_count
     FROM sfism4.r_wip_keyparts_t k, sfis1.c_keyparts_desc_t d
    WHERE     k.key_part_no = d.key_part_no
          AND d.TYPE = 'LOGIC UPPER'
          AND k.serial_number = q_sn;

   IF c_count > 0
   THEN
      SELECT k.key_part_no
        INTO q_logicupper
        FROM sfism4.r_wip_keyparts_t k, sfis1.c_keyparts_desc_t d
       WHERE     k.key_part_no = d.key_part_no
             AND d.TYPE = 'LOGIC UPPER'
             AND k.serial_number = q_sn
             AND ROWNUM = 1;
   ELSE
      q_logicupper := '';
   END IF;

   content2 :=
      content2 || 'SET LOGICUPPER=' || q_logicupper || CHR (13) || CHR (10);

   --END LOGIC UPPER

   --GET CD AFT_EQUIPMENT HANK -20220309
   SELECT COUNT (p.spec1)
     INTO c_equipment
     FROM sfism4.r_wip_log_t w, sfis1.c_part_control_t p
    WHERE     p.part_type = 'AFT_EQUIPMENT'
          AND w.line_name = p.cust_part_no
          AND w.group_name IN ('STRU', 'PLABEL_CHECK')
          AND w.in_station_time IN (SELECT MAX (wl.in_station_time)
                                      FROM sfism4.r_wip_log_t wl
                                     WHERE     wl.group_name IN ('STRU',
                                                                 'PLABEL_CHECK')
                                           AND wl.serial_number = q_sn)
          AND w.serial_number = q_sn;

   IF c_equipment > 0
   THEN
      SELECT p.spec1
        INTO q_equipment
        FROM sfism4.r_wip_log_t w, sfis1.c_part_control_t p
       WHERE     p.part_type = 'AFT_EQUIPMENT'
             AND w.line_name = p.cust_part_no
             AND w.group_name IN ('STRU', 'PLABEL_CHECK')
             AND w.in_station_time IN (SELECT MAX (wl.in_station_time)
                                         FROM sfism4.r_wip_log_t wl
                                        WHERE     wl.group_name IN ('STRU',
                                                                    'PLABEL_CHECK')
                                              AND wl.serial_number = q_sn)
             AND w.serial_number = q_sn
             AND ROWNUM = 1;

      content2 :=
            content2
         || 'SET AFT_EQUIPMENT='
         || q_equipment
         || CHR (13)
         || CHR (10);
   ELSE
      content2 :=
         content2 || 'SET AFT_EQUIPMENT=EMPTY' || CHR (13) || CHR (10);
   END IF;

   --GET CD AFT_EQUIPMENT HANK -20220309

   --Get CTY Rugged WWAN,WLAN Jonathan -20220408
   SELECT COUNT (wk.serial_number)
     INTO c_count
     FROM sfism4.r_wip_keyparts_t wk, sfis1.c_keyparts_desc_t kd
    WHERE     wk.key_part_no = kd.key_part_no
          AND kd.TYPE = 'WWAN'
          AND wk.serial_number = q_sn;

   IF c_count > 0
   THEN
      SELECT NVL (kd.spec8, 'EMPTY')
        INTO q_wwan_rf
        FROM sfism4.r_wip_keyparts_t wk, sfis1.c_keyparts_desc_t kd
       WHERE     wk.key_part_no = kd.key_part_no
             AND kd.TYPE = 'WWAN'
             AND wk.serial_number = q_sn;
   ELSE
      q_wwan_rf := 'EMPTY';
   END IF;

   content2 := content2 || 'SET WWAN_RF=' || q_wwan_rf || CHR (13) || CHR (10);

   SELECT COUNT (wk.serial_number)
     INTO c_count
     FROM sfism4.r_wip_keyparts_t wk, sfis1.c_keyparts_desc_t kd
    WHERE     wk.key_part_no = kd.key_part_no
          AND kd.TYPE = 'WLAN'
          AND wk.serial_number = q_sn;

   IF c_count > 0
   THEN
      SELECT NVL (kd.spec8, 'EMPTY')
        INTO q_wlan_rf
        FROM sfism4.r_wip_keyparts_t wk, sfis1.c_keyparts_desc_t kd
       WHERE     wk.key_part_no = kd.key_part_no
             AND kd.TYPE = 'WLAN'
             AND wk.serial_number = q_sn;
   ELSE
      q_wlan_rf := 'EMPTY';
   END IF;

   content2 := content2 || 'SET WLAN_RF=' || q_wlan_rf || CHR (13) || CHR (10);

   SELECT COUNT (wk.serial_number)
     INTO c_count
     FROM sfism4.r_wip_keyparts_t wk, sfis1.c_keyparts_desc_t kd
    WHERE     wk.key_part_no = kd.key_part_no
          AND kd.TYPE = 'ANTENNA'
          AND wk.serial_number = q_sn
          AND kd.spec8 IS NOT NULL;

   IF c_count > 0
   THEN
      SELECT NVL (kd.spec8, 'EMPTY')
        INTO q_rugged_ptb
        FROM sfism4.r_wip_keyparts_t wk, sfis1.c_keyparts_desc_t kd
       WHERE     wk.key_part_no = kd.key_part_no
             AND kd.TYPE = 'ANTENNA'
             AND wk.serial_number = q_sn
             AND kd.spec8 IS NOT NULL
             AND ROWNUM = 1;
   ELSE
      q_rugged_ptb := 'EMPTY';
   END IF;

   content2 :=
      content2 || 'SET RUGGED_PTB=' || q_rugged_ptb || CHR (13) || CHR (10);

   content2 := content2 || 'SET RESULT=PASS' || CHR (13) || CHR (10);

   --Get CTY Rugged WWAN,WLAN Jonathan -20220408

   --Get CTY Rugged RUGGED_PSENSOR Eddie -20220831
   SELECT COUNT (wk.serial_number)
     INTO c_count
     FROM sfism4.r_wip_keyparts_t wk, sfis1.c_part_control_t pc
    WHERE     wk.key_part_no = pc.key_part_no
          AND pc.part_type = 'RUGGED_PSENSOR'
          AND wk.serial_number = q_sn;

   IF c_count > 0
   THEN
      q_rugged_psensor := 'EXIST';
   ELSE
      q_rugged_psensor := 'EMPTY';
   END IF;

   content2 :=
         content2
      || 'SET RUGGED_PSENSOR='
      || q_rugged_psensor
      || CHR (13)
      || CHR (10);

   --Get CTY Rugged RUGGED_PSENSOR Eddie -20220831

   --Get CTY Rugged Eddie -20221129
   SELECT COUNT (b.serial_number)
     INTO c_count
     FROM sfism4.r_wip_keyparts_t b, sfis1.c_keyparts_desc_t a,
          sfism4.r_wip_tracking_t w
    WHERE     b.serial_number = w.serial_number
          AND a.key_part_no = b.key_part_no
          AND w.serial_number = q_sn
          AND a.TYPE = 'LCD BEZEL';

   IF c_count > 0
   THEN
      SELECT a.kp_desc
        INTO q_lcd_bezel_desc
        FROM sfism4.r_wip_keyparts_t b, sfis1.c_keyparts_desc_t a,
             sfism4.r_wip_tracking_t w
       WHERE     b.serial_number = w.serial_number
             AND a.key_part_no = b.key_part_no
             AND w.serial_number = q_sn
             AND a.TYPE = 'LCD BEZEL';
   ELSE
      SELECT COUNT (b.serial_number)
        INTO c_count
        FROM sfism4.r_wip_keyparts_t b, sfis1.c_keyparts_desc_t a,
             sfism4.r_wip_tracking_t w
       WHERE     b.serial_number = w.serial_number
             AND a.key_part_no = b.key_part_no
             AND w.serial_number = q_sn
             AND a.TYPE = 'BEZEL';

      IF c_count > 0
      THEN
         SELECT a.kp_desc
           INTO q_lcd_bezel_desc
           FROM sfism4.r_wip_keyparts_t b, sfis1.c_keyparts_desc_t a,
                sfism4.r_wip_tracking_t w
          WHERE     b.serial_number = w.serial_number
                AND a.key_part_no = b.key_part_no
                AND w.serial_number = q_sn
                AND a.TYPE = 'BEZEL';
      ELSE
         q_lcd_bezel_desc := 'EMPTY';
      END IF;
   END IF;

   content2 :=
         content2
      || 'SET LCD_BEZEL_DESC='
      || q_lcd_bezel_desc
      || CHR (13)
      || CHR (10);

   SELECT COUNT (b.serial_number)
     INTO c_count
     FROM sfism4.r_wip_keyparts_t b, sfis1.c_keyparts_desc_t a,
          sfism4.r_wip_tracking_t w
    WHERE     b.serial_number = w.serial_number
          AND a.key_part_no = b.key_part_no
          AND w.serial_number = q_sn
          AND a.TYPE = 'MIC';

   IF c_count > 0
   THEN
      SELECT a.kp_desc
        INTO q_mic_desc
        FROM sfism4.r_wip_keyparts_t b, sfis1.c_keyparts_desc_t a,
             sfism4.r_wip_tracking_t w
       WHERE     b.serial_number = w.serial_number
             AND a.key_part_no = b.key_part_no
             AND w.serial_number = q_sn
             AND a.TYPE = 'MIC'
             AND ROWNUM = 1;
   ELSE
      q_mic_desc := 'EMPTY';
   END IF;

   content2 :=
      content2 || 'SET MIC_DESC=' || q_mic_desc || CHR (13) || CHR (10);

   SELECT COUNT (wk.serial_number)
     INTO c_count
     FROM sfism4.r_wip_keyparts_t wk, sfis1.c_keyparts_desc_t kd
    WHERE     wk.key_part_no = kd.key_part_no
          AND wk.serial_number = q_sn
          AND kd.TYPE = 'RJ45';

   IF c_count > 0
   THEN
      SELECT COUNT (k.serial_number)
        INTO c_count
        FROM sfism4.r_wip_keyparts_t k, sfism4.r_wip_tracking_t p,
             sfis1.c_keyparts_desc_t d
       WHERE     k.key_part_sn = p.serial_number
             AND k.serial_number = q_sn
             AND p.lan_address IS NOT NULL
             AND k.key_part_no = d.key_part_no
             AND d.TYPE IN ('LAN/B', '');

      IF (c_count > 0)
      THEN
         SELECT p.lan_address
           INTO q_rugged_lan
           FROM sfism4.r_wip_keyparts_t k, sfism4.r_wip_tracking_t p,
                sfis1.c_keyparts_desc_t d
          WHERE     k.key_part_sn = p.serial_number
                AND k.serial_number = q_sn
                AND p.lan_address IS NOT NULL
                AND k.key_part_no = d.key_part_no
                AND d.TYPE IN ('LAN/B', '');
      ELSE
         q_rugged_lan := 'EMPTY';
      END IF;
   ELSE
      q_rugged_lan := 'EMPTY';
   END IF;

   content2 :=
      content2 || 'SET RUGGED_LAN=' || q_rugged_lan || CHR (13) || CHR (10);

   SELECT COUNT (wk.serial_number)
     INTO c_count
     FROM sfism4.r_wip_keyparts_t wk, sfis1.c_keyparts_desc_t kd
    WHERE     wk.key_part_no = kd.key_part_no
          AND wk.serial_number = q_sn
          AND kd.TYPE = 'TOP SCANNER';

   IF (c_count > 0)
   THEN
      q_rugged_scanner := 'EXIST';
   ELSE
      q_rugged_scanner := 'EMPTY';
   END IF;

   content2 :=
         content2
      || 'SET RUGGED_SCANNER='
      || q_rugged_scanner
      || CHR (13)
      || CHR (10);

   SELECT COUNT (wk.serial_number)
     INTO c_count
     FROM sfism4.r_wip_keyparts_t wk, sfis1.c_keyparts_desc_t kd
    WHERE     wk.key_part_no = kd.key_part_no
          AND wk.serial_number = q_sn
          AND kd.TYPE = 'RUGGED';

   IF (c_count > 0)
   THEN
      q_rugged_fischr := 'EXIST';
   ELSE
      q_rugged_fischr := 'EMPTY';
   END IF;

   content2 :=
         content2
      || 'SET RUGGED_FISCHER='
      || q_rugged_fischr
      || CHR (13)
      || CHR (10);

   SELECT COUNT (wk.serial_number)
     INTO c_count
     FROM sfism4.r_wip_keyparts_t wk, sfis1.c_keyparts_desc_t kd
    WHERE     wk.key_part_no = kd.key_part_no
          AND wk.serial_number = q_sn
          AND kd.TYPE = 'MINI RS232';

   IF (c_count > 0)
   THEN
      q_rugged_rs232 := 'EXIST';
   ELSE
      q_rugged_rs232 := 'EMPTY';
   END IF;

   content2 :=
         content2
      || 'SET RUGGED_RS232='
      || q_rugged_rs232
      || CHR (13)
      || CHR (10);

   SELECT COUNT (wk.serial_number)
     INTO c_count
     FROM sfism4.r_wip_keyparts_t wk, sfis1.c_keyparts_desc_t kd
    WHERE     wk.key_part_no = kd.key_part_no
          AND wk.serial_number = q_sn
          AND kd.TYPE = 'FFC MODULE';

   IF (c_count > 0)
   THEN
      q_rugged_cameraf := 'EXIST';
      q_rugged_camerbf := 'EXIST';
   ELSE
      q_rugged_cameraf := 'EMPTY';
      q_rugged_camerbf := 'EMPTY';
   END IF;

   content2 :=
         content2
      || 'SET RUGGED_CAMERAF='
      || q_rugged_cameraf
      || CHR (13)
      || CHR (10);
   content2 :=
         content2
      || 'SET RUGGED_CAMERBF='
      || q_rugged_camerbf
      || CHR (13)
      || CHR (10);

   SELECT COUNT (wk.serial_number)
     INTO c_count
     FROM sfism4.r_wip_keyparts_t wk, sfis1.c_keyparts_desc_t kd
    WHERE     wk.key_part_no = kd.key_part_no
          AND wk.serial_number = q_sn
          AND kd.TYPE = 'PWR/USH';

   IF (c_count > 0)
   THEN
      q_rugged_ush := 'EXIST';
   ELSE
      q_rugged_ush := 'EMPTY';
   END IF;

   content2 :=
      content2 || 'SET RUGGED_USH=' || q_rugged_ush || CHR (13) || CHR (10);

   SELECT COUNT (wk.serial_number)
     INTO c_count
     FROM sfism4.r_wip_keyparts_t wk, sfis1.c_keyparts_desc_t kd
    WHERE     wk.key_part_no = kd.key_part_no
          AND wk.serial_number = q_sn
          AND kd.TYPE = 'ANTENNA/NFC';

   IF (c_count > 0)
   THEN
      q_rugged_nfc := 'EXIST';
   ELSE
      q_rugged_nfc := 'EMPTY';
   END IF;

   content2 :=
      content2 || 'SET RUGGED_NFC=' || q_rugged_nfc || CHR (13) || CHR (10);

   SELECT COUNT (wk.serial_number)
     INTO c_count
     FROM sfism4.r_wip_keyparts_t wk, sfis1.c_keyparts_desc_t kd
    WHERE     wk.key_part_no = kd.key_part_no
          AND wk.serial_number = q_sn
          AND kd.TYPE = 'FPRINT';

   IF (c_count > 0)
   THEN
      q_rugged_fprint := 'EXIST';
   ELSE
      q_rugged_fprint := 'EMPTY';
   END IF;

   content2 :=
         content2
      || 'SET RUGGED_FPRINT='
      || q_rugged_fprint
      || CHR (13)
      || CHR (10);

   SELECT COUNT (wk.serial_number)
     INTO c_count
     FROM sfism4.r_wip_keyparts_t wk, sfis1.c_keyparts_desc_t kd
    WHERE     wk.key_part_no = kd.key_part_no
          AND wk.serial_number = q_sn
          AND kd.TYPE = 'SMALL/SMART';

   IF (c_count > 0)
   THEN
      q_rugged_smart := 'EXIST';
   ELSE
      q_rugged_smart := 'EMPTY';
   END IF;

   content2 :=
         content2
      || 'SET RUGGED_SMART='
      || q_rugged_smart
      || CHR (13)
      || CHR (10);

   SELECT COUNT (wk.serial_number)
     INTO c_count
     FROM sfism4.r_wip_keyparts_t wk, sfis1.c_keyparts_desc_t kd
    WHERE     wk.key_part_no = kd.key_part_no
          AND wk.serial_number = q_sn
          AND kd.TYPE = 'IDE HDMI';

   IF (c_count > 0)
   THEN
      q_rugged_hdmi := 'EXIST';
   ELSE
      q_rugged_hdmi := 'EMPTY';
   END IF;

   content2 :=
      content2 || 'SET RUGGED_HDMI=' || q_rugged_hdmi || CHR (13) || CHR (10);

   SELECT COUNT (wk.serial_number)
     INTO c_count
     FROM sfism4.r_wip_keyparts_t wk, sfis1.c_keyparts_desc_t kd
    WHERE     wk.key_part_no = kd.key_part_no
          AND wk.serial_number = q_sn
          AND kd.TYPE = 'SIDE USB';

   IF (c_count > 0)
   THEN
      q_rugged_usbio := 'EXIST';
   ELSE
      q_rugged_usbio := 'EMPTY';
   END IF;

   content2 :=
         content2
      || 'SET RUGGED_USBIO='
      || q_rugged_usbio
      || CHR (13)
      || CHR (10);

   SELECT COUNT (wk.serial_number)
     INTO c_count
     FROM sfism4.r_wip_keyparts_t wk, sfis1.c_keyparts_desc_t kd
    WHERE     wk.key_part_no = kd.key_part_no
          AND wk.serial_number = q_sn
          AND kd.TYPE = 'BATT';

   IF (c_count >= 2)
   THEN
      q_rugged_2ndbattery := 'EXIST';
   ELSE
      q_rugged_2ndbattery := 'EMPTY';
   END IF;

   content2 :=
         content2
      || 'SET RUGGED_2NDBATTERY='
      || q_rugged_2ndbattery
      || CHR (13)
      || CHR (10);

   --Get CTY Rugged Eddie -20221129

   --Get CTY Rugged WLAN_ANT & WWAN_ANT Jonathan -20230329
   SELECT COUNT (wk.serial_number)
     INTO c_count
     FROM sfism4.r_wip_keyparts_t wk, sfis1.c_part_control_t pc
    WHERE     wk.key_part_no = pc.key_part_no
          AND pc.part_type = 'WLAN_ANT'
          AND wk.serial_number = q_sn;

   IF c_count > 0
   THEN
      q_wlan_ant := 'EXIST';
   ELSE
      q_wlan_ant := 'EMPTY';
   END IF;

   content2 :=
      content2 || 'SET WLAN_ANT=' || q_wlan_ant || CHR (13) || CHR (10);

   SELECT COUNT (wk.serial_number)
     INTO c_count
     FROM sfism4.r_wip_keyparts_t wk, sfis1.c_part_control_t pc
    WHERE     wk.key_part_no = pc.key_part_no
          AND pc.part_type = 'WWAN_ANT'
          AND wk.serial_number = q_sn;

   IF c_count > 0
   THEN
      q_wwan_ant := 'EXIST';
   ELSE
      q_wwan_ant := 'EMPTY';
   END IF;

   content2 :=
      content2 || 'SET WWAN_ANT=' || q_wwan_ant || CHR (13) || CHR (10);
   --Get CTY Rugged WLAN_ANT & WWAN_ANT Jonathan -20230329

   o_status := ' PASS ';
   o_msg := ' OK ';
   content2 = SUBSTR(content2,1,2000)
EXCEPTION
   WHEN OTHERS
   THEN
      o_status := ' FAIL ';
      o_msg := ' FMDI_TPDL_BOMINFO1 EXCEPTION ';
      content1 := ' SET RESULT = FAIL ' || CHR (13) || CHR (10);
      content1 :=
         content1 || ' SET REASON = ' || o_msg || CHR (13) || CHR (10);
	  content1 = SUBSTR(content1,1,2000)
	  content2 = SUBSTR(content2,1,2000)
END c_fmdi_tpdl_bominfo1;