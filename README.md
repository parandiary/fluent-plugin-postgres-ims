# fluent-plugin-postgres, a plugin for [Fluentd](http://fluentd.org)


## Changed
add option parameter
options=-c%20search_path%3Dcipdev%20-c%20application_name%3Dfluentd-ims%20-c%20default_transaction_read_only%3Dfalse'



### Quick example
  <match fuse-file>
    @type postgresims
    host 192.168.1.220
    port 5433
    database ke_ims_v7
    username rnd
    password rnd
#    options 'keepalives=1&connect_timeout=10&options=-c%20search_path%3Dcipdev%20-c%20application_name%3Dfluentd-ims%20-c%20default_transaction_read_only%3Dtrue'
    options 'keepalives=1&connect_timeout=10&options=-c%20search_path%3Dcipdev%20-c%20application_name%3Dfluentd-ims%20-c%20default_transaction_read_only%3Dfalse'
    key_names ptDt, bguId, guId, ifId, hopCnt, procTm, procTmCust01, procTmCust02, procTmCust03, procTmCust04, procTmCust05, processType, sndSysNm, rcvSysNm, sndIp , rcvIp, rtnCd, errCd, errMsg, errDetail, dataLen, qmgrNm, bkNm, egNm, mfNm, qNm, transType, msgAllCnt, msgSucCnt, ifType, flag, rcol1, rcol2, rcol3, rcol4, rcol5, rcol6, rcol7, rcol8, rcol9, rcol10, rcol11, rcol12, rcol13
    sql INSERT INTO cipdev.rm_log_buf_apg (pt_dt, bgu_id, gu_id, if_id, hop_cnt, proc_tm, proc_tm_cust_01, proc_tm_cust_02, proc_tm_cust_03, proc_tm_cust_04, proc_tm_cust_05, process_type, snd_sys_nm, rcv_sys_nm, snd_ip, rcv_ip, rtn_cd, err_cd, err_msg, err_detail, data_len, qmgr_nm, bk_nm, eg_nm, mf_nm, q_nm, trans_type, msg_all_cnt, msg_suc_cnt, if_type, flag, rcol_1, rcol_2, rcol_3, rcol_4, rcol_5, rcol_6, rcol_7, rcol_8, rcol_9, rcol_10, rcol_11, rcol_12, rcol_13, insert_dt) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $30, $31, $32, $33, $34, $35, $36, $37, $38, $39, $40, $41, $42, $43, $44, TO_CHAR(current_timestamp, 'yyyymmddHH24MISSFF3'))
    flush_interval 1s
        <buffer>
            @type file
            path /apps/ims/td-agent/fluentd-buffers/ims.transaction.buffer
            flush_mode interval
            flush_thread_count 5
            flush_interval 1s
            retry_max_interval 30
            chunk_limit_size 100M
            queue_limit_length 3000
            #overflow_action drop_oldest_chunk
                        overflow_action block
        </buffer>
  </match>
</label>



## Installation:

- Prereq: Install postgresql headers: `apt-get install libpq-dev`
- Install the gem:
  - `gem install fluent-plugin-postgres` or
  - `/usr/lib/fluent/ruby/bin/fluent-gem install fluent-plugin-postgres`

## Changes from mysql:

- We currently don't support json format
- You need to specify a SQL query
- Placeholders are numbered (yeah, I know).

Other than that, just bear in mind that it's Postgres SQL.

### Quick example

    <match output.by.sql.*>
      type postgres
      host master.db.service.local
      # port 3306 # default
      database application_logs
      username myuser
      password mypass
      key_names status,bytes,vhost,path,rhost,agent,referer
      sql INSERT INTO accesslog (status,bytes,vhost,path,rhost,agent,referer) VALUES ($1,$2,$3,$4,$5,$6,$7)
      flush_intervals 5s
    </match>



## Component

### PostgresOutput

Plugin to store Postgres tables over SQL, to each columns per values, or to single column as json.

## Configuration

### MysqlOutput

MysqlOutput needs MySQL server's host/port/database/username/password, and INSERT format as SQL, or as table name and columns.

    <match output.by.sql.*>
      type mysql
      host master.db.service.local
      # port 3306 # default
      database application_logs
      username myuser
      password mypass
      key_names status,bytes,vhost,path,rhost,agent,referer
      sql INSERT INTO accesslog (status,bytes,vhost,path,rhost,agent,referer) VALUES (?,?,?,?,?,?,?)
      flush_intervals 5s
    </match>

    <match output.by.names.*>
      type mysql
      host master.db.service.local
      database application_logs
      username myuser
      password mypass
      key_names status,bytes,vhost,path,rhost,agent,referer
      table accesslog
      # 'columns' names order must be same with 'key_names'
      columns status,bytes,vhost,path,rhost,agent,referer
      flush_intervals 5s
    </match>

Or, insert json into single column.

    <match output.as.json.*>
      type mysql
      host master.db.service.local
      database application_logs
      username root
      table accesslog
      columns jsondata
      format json
      flush_intervals 5s
    </match>

To include time/tag into output, use `include_time_key` and `include_tag_key`, like this:

    <match output.with.tag.and.time.*>
      type mysql
      host my.mysql.local
      database anydatabase
      username yourusername
      password secret

      include_time_key yes
      ### default `time_format` is ISO-8601
      # time_format %Y%m%d-%H%M%S
      ### default `time_key` is 'time'
      # time_key timekey

      include_tag_key yes
      ### default `tag_key` is 'tag'
      # tag_key tagkey

      table anydata
      key_names time,tag,field1,field2,field3,field4
      sql INSERT INTO baz (coltime,coltag,col1,col2,col3,col4) VALUES (?,?,?,?,?,?)
    </match>

Or, for json:

    <match output.with.tag.and.time.as.json.*>
      type mysql
      host database.local
      database foo
      username root

      include_time_key yes
      utc   # with UTC timezome output (default: localtime)
      time_format %Y%m%d-%H%M%S
      time_key timeattr

      include_tag_key yes
      tag_key tagattr
      table accesslog
      columns jsondata
      format json
    </match>
    #=> inserted json data into column 'jsondata' with addtional attribute 'timeattr' and 'tagattr'

## TODO

* implement 'tag_mapped'
  * dynamic tag based table selection

## Copyright

* Copyright
  * Copyright 2013 Uken Games
* License
  * Apache License, Version 2.0
