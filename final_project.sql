PGDMP                         z            final_project    14.2    14.2 8    ?           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            @           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            A           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            B           1262    26202    final_project    DATABASE     n   CREATE DATABASE final_project WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Vietnamese_Vietnam.1258';
    DROP DATABASE final_project;
                postgres    false            �            1255    26203    auto_base_salary()    FUNCTION     �   CREATE FUNCTION public.auto_base_salary() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
begin
	update nhanvien 
	set luong_co_ban =  (select luong_co_ban  from chucvu
	where chucvu.chucvu_id=nhanvien.chucvu_id) ; 	
	return null;
	end;
$$;
 )   DROP FUNCTION public.auto_base_salary();
       public          postgres    false            �            1255    26204    auto_price()    FUNCTION       CREATE FUNCTION public.auto_price() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
meal_true_price character varying(100);
begin
	update order_and_payment 
	set price = counts* (select price  from menu
	where menu.meal_id=order_and_payment.meal_id) ; 	
	return null;
	end;
$$;
 #   DROP FUNCTION public.auto_price();
       public          postgres    false            �            1255    26205 <   booking(integer, character varying, character varying, date)    FUNCTION     {  CREATE FUNCTION public.booking(table_id integer, customer_id character varying, note character varying, appointment_date date) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
		declare
		begin
		insert into public.set_table(table_id,customer_id,appointment_date,note)
		values (table_id, customer_id,appointment_date,note);
		return 'booking successfully';
		end;
		$$;
 ~   DROP FUNCTION public.booking(table_id integer, customer_id character varying, note character varying, appointment_date date);
       public          postgres    false            �            1255    26206 )   cancel_set_table(character varying, date)    FUNCTION     K  CREATE FUNCTION public.cancel_set_table(customer_id character varying, appointment_date date) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
	declare
	begin
		delete from public.order_and_payment op
		where op.customer_id=customer_id and op.appointment_date = appointment_date;
		return "cancel successfully";
	end;
	$$;
 ]   DROP FUNCTION public.cancel_set_table(customer_id character varying, appointment_date date);
       public          postgres    false            �            1255    26207    check_booking()    FUNCTION     
  CREATE FUNCTION public.check_booking() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
	valid_date date;
begin
	if new.appointment_date <CURRENT_DATE then
		raise notice 'Ngay hen lich trong qua khu,khong hop le';
		return null;
	end if;
	return new;
end
$$;
 &   DROP FUNCTION public.check_booking();
       public          postgres    false            �            1255    26208    doanh_thu_ngay()    FUNCTION     �   CREATE FUNCTION public.doanh_thu_ngay() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare

begin
	update doanh_thu 
	set revenue = (select sum(price) from order_and_payment op
				   where op.date_time=doanh_thu.date_time);
	return null;
	end;
$$;
 '   DROP FUNCTION public.doanh_thu_ngay();
       public          postgres    false            �            1255    26209    hesonhanvien()    FUNCTION     "  CREATE FUNCTION public.hesonhanvien() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
a date;
begin
	if (date_part('year', current_date::date)- date_part('year',new.ngay_bat_dau::date)>3) then
		update public.nhanvien
		set heso= 3
		where ngay_bat_dau=new.ngay_bat_dau;
		return null;
	end if;
	if (date_part('year', current_date::date)- date_part('year',new.ngay_bat_dau::date)>2 
	and date_part('year', current_date::date)- date_part('year',new.ngay_bat_dau::date)<4) then
		update public.nhanvien
		set heso=2
		where ngay_bat_dau=new.ngay_bat_dau;
		return null;
	end if;
	if (date_part('year', current_date::date)- date_part('year',new.ngay_bat_dau::date)<=2) then
		update public.nhanvien
		set heso=1
		where ngay_bat_dau=new.ngay_bat_dau;
		return null;
	end if;
	return null;
end;
$$;
 %   DROP FUNCTION public.hesonhanvien();
       public          postgres    false            �            1255    26210 N   insert_customer(character varying, character varying, character varying, date)    FUNCTION     �  CREATE FUNCTION public.insert_customer(customer_id character varying, customer_name character varying, email character varying, dob date) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
				declare
				begin
				insert into public.customer(customer_id,customer_name,email,date_of_birth)
				values (customer_id,customer_name,email,dob);
				return "insert successfully";
				end;
				$$;
 �   DROP FUNCTION public.insert_customer(customer_id character varying, customer_name character varying, email character varying, dob date);
       public          postgres    false            �            1255    26211    nhap_ngay(date, date)    FUNCTION       CREATE FUNCTION public.nhap_ngay(start_dt date, end_dt date) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
declare 
	al date;
begin	
	al=start_dt;
while al<=end_dt loop
	insert into public.doanh_thu(date_time) values(al);
	al=al+1;	 
	end loop;
return 'sucecc';
end;
$$;
 <   DROP FUNCTION public.nhap_ngay(start_dt date, end_dt date);
       public          postgres    false            �            1259    26212 	   set_table    TABLE     �   CREATE TABLE public.set_table (
    table_id integer NOT NULL,
    customer_id character varying(13) NOT NULL,
    appointment_date date NOT NULL,
    note character varying(500)
);
    DROP TABLE public.set_table;
       public         heap    postgres    false            �            1259    26217    appointment_table    VIEW     �   CREATE VIEW public.appointment_table AS
 SELECT set_table.table_id AS booked_table_id,
    set_table.appointment_date
   FROM public.set_table;
 $   DROP VIEW public.appointment_table;
       public          postgres    false    209    209            �            1259    26221    chucvu    TABLE     �   CREATE TABLE public.chucvu (
    chucvu_id integer NOT NULL,
    ten_chuc_vu character varying(50) NOT NULL,
    luong_co_ban integer NOT NULL
);
    DROP TABLE public.chucvu;
       public         heap    postgres    false            �            1259    26224    customer    TABLE     �   CREATE TABLE public.customer (
    customer_id character varying(13) NOT NULL,
    customer_name character varying(50) NOT NULL,
    email character varying(50),
    date_of_birth date NOT NULL
);
    DROP TABLE public.customer;
       public         heap    postgres    false            �            1259    26227 	   doanh_thu    TABLE     T   CREATE TABLE public.doanh_thu (
    date_time date NOT NULL,
    revenue integer
);
    DROP TABLE public.doanh_thu;
       public         heap    postgres    false            �            1259    26230    menu    TABLE     �   CREATE TABLE public.menu (
    meal_id integer NOT NULL,
    meal_name character varying(50) NOT NULL,
    price integer NOT NULL
);
    DROP TABLE public.menu;
       public         heap    postgres    false            �            1259    26233    nhanvien    TABLE       CREATE TABLE public.nhanvien (
    nhanvien_id integer NOT NULL,
    ten_nhan_vien character varying(50) NOT NULL,
    ngay_bat_dau date NOT NULL,
    chucvu_id integer NOT NULL,
    heso integer NOT NULL,
    luong_co_ban integer,
    luong_thuc_te integer
);
    DROP TABLE public.nhanvien;
       public         heap    postgres    false            �            1259    26236    order_and_payment    TABLE     �   CREATE TABLE public.order_and_payment (
    table_id integer NOT NULL,
    customer_id character varying(13) NOT NULL,
    meal_id integer NOT NULL,
    counts integer NOT NULL,
    date_time date NOT NULL,
    price integer
);
 %   DROP TABLE public.order_and_payment;
       public         heap    postgres    false            �            1259    26239    payment    VIEW     7  CREATE VIEW public.payment AS
SELECT
    NULL::integer AS table_id,
    NULL::character varying(13) AS customer_id,
    NULL::date AS date_time,
    NULL::integer AS meal_id,
    NULL::character varying(50) AS meal_name,
    NULL::integer AS counts,
    NULL::integer AS price,
    NULL::bigint AS total_price;
    DROP VIEW public.payment;
       public          postgres    false            �            1259    26243    tables    TABLE     ]   CREATE TABLE public.tables (
    table_id integer NOT NULL,
    nhan_vien_phuc_vu integer
);
    DROP TABLE public.tables;
       public         heap    postgres    false            6          0    26221    chucvu 
   TABLE DATA           F   COPY public.chucvu (chucvu_id, ten_chuc_vu, luong_co_ban) FROM stdin;
    public          postgres    false    211   �Q       7          0    26224    customer 
   TABLE DATA           T   COPY public.customer (customer_id, customer_name, email, date_of_birth) FROM stdin;
    public          postgres    false    212   R       8          0    26227 	   doanh_thu 
   TABLE DATA           7   COPY public.doanh_thu (date_time, revenue) FROM stdin;
    public          postgres    false    213   td      9          0    26230    menu 
   TABLE DATA           9   COPY public.menu (meal_id, meal_name, price) FROM stdin;
    public          postgres    false    214   �j      :          0    26233    nhanvien 
   TABLE DATA           z   COPY public.nhanvien (nhanvien_id, ten_nhan_vien, ngay_bat_dau, chucvu_id, heso, luong_co_ban, luong_thuc_te) FROM stdin;
    public          postgres    false    215   ql      ;          0    26236    order_and_payment 
   TABLE DATA           e   COPY public.order_and_payment (table_id, customer_id, meal_id, counts, date_time, price) FROM stdin;
    public          postgres    false    216    n      5          0    26212 	   set_table 
   TABLE DATA           R   COPY public.set_table (table_id, customer_id, appointment_date, note) FROM stdin;
    public          postgres    false    209   `n      <          0    26243    tables 
   TABLE DATA           =   COPY public.tables (table_id, nhan_vien_phuc_vu) FROM stdin;
    public          postgres    false    218   �n      �           2606    26247    chucvu chucvu_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.chucvu
    ADD CONSTRAINT chucvu_pkey PRIMARY KEY (chucvu_id);
 <   ALTER TABLE ONLY public.chucvu DROP CONSTRAINT chucvu_pkey;
       public            postgres    false    211            �           2606    26249    customer customer_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (customer_id);
 @   ALTER TABLE ONLY public.customer DROP CONSTRAINT customer_pkey;
       public            postgres    false    212            �           2606    26251    doanh_thu doanh_thu_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.doanh_thu
    ADD CONSTRAINT doanh_thu_pkey PRIMARY KEY (date_time);
 B   ALTER TABLE ONLY public.doanh_thu DROP CONSTRAINT doanh_thu_pkey;
       public            postgres    false    213            �           2606    26253    menu menu_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.menu
    ADD CONSTRAINT menu_pkey PRIMARY KEY (meal_id);
 8   ALTER TABLE ONLY public.menu DROP CONSTRAINT menu_pkey;
       public            postgres    false    214            �           2606    26255    nhanvien nhanvien_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.nhanvien
    ADD CONSTRAINT nhanvien_pkey PRIMARY KEY (nhanvien_id);
 @   ALTER TABLE ONLY public.nhanvien DROP CONSTRAINT nhanvien_pkey;
       public            postgres    false    215            �           2606    26257 (   order_and_payment order_and_payment_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.order_and_payment
    ADD CONSTRAINT order_and_payment_pkey PRIMARY KEY (table_id, customer_id, date_time);
 R   ALTER TABLE ONLY public.order_and_payment DROP CONSTRAINT order_and_payment_pkey;
       public            postgres    false    216    216    216            �           2606    26259    set_table set_table_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.set_table
    ADD CONSTRAINT set_table_pkey PRIMARY KEY (customer_id, table_id);
 B   ALTER TABLE ONLY public.set_table DROP CONSTRAINT set_table_pkey;
       public            postgres    false    209    209            �           2606    26261    tables tables_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.tables
    ADD CONSTRAINT tables_pkey PRIMARY KEY (table_id);
 <   ALTER TABLE ONLY public.tables DROP CONSTRAINT tables_pkey;
       public            postgres    false    218            �           1259    27011    _index_customer_name    INDEX     R   CREATE INDEX _index_customer_name ON public.customer USING btree (customer_name);
 (   DROP INDEX public._index_customer_name;
       public            postgres    false    212            �           1259    26264 !   fki_tables_nhan_vien_phuc_vu_fkey    INDEX     a   CREATE INDEX fki_tables_nhan_vien_phuc_vu_fkey ON public.tables USING btree (nhan_vien_phuc_vu);
 5   DROP INDEX public.fki_tables_nhan_vien_phuc_vu_fkey;
       public            postgres    false    218            �           1259    26265 #   index_order_and_payment_customer_id    INDEX     h   CREATE INDEX index_order_and_payment_customer_id ON public.order_and_payment USING btree (customer_id);
 7   DROP INDEX public.index_order_and_payment_customer_id;
       public            postgres    false    216            4           2618    26242    payment _RETURN    RULE     �  CREATE OR REPLACE VIEW public.payment AS
 SELECT op.table_id,
    op.customer_id,
    op.date_time,
    op.meal_id,
    mn.meal_name,
    op.counts,
    mn.price,
    sum((op.counts * mn.price)) AS total_price
   FROM (public.order_and_payment op
     LEFT JOIN public.menu mn ON ((op.meal_id = mn.meal_id)))
  GROUP BY op.table_id, op.customer_id, op.meal_id, op.date_time, mn.price, mn.meal_name;
 B  CREATE OR REPLACE VIEW public.payment AS
SELECT
    NULL::integer AS table_id,
    NULL::character varying(13) AS customer_id,
    NULL::date AS date_time,
    NULL::integer AS meal_id,
    NULL::character varying(50) AS meal_name,
    NULL::integer AS counts,
    NULL::integer AS price,
    NULL::bigint AS total_price;
       public          postgres    false    3223    214    216    216    216    216    216    214    214    217            �           2620    26267    nhanvien auto_base_salary    TRIGGER     �   CREATE TRIGGER auto_base_salary AFTER INSERT OR UPDATE ON public.nhanvien FOR EACH ROW WHEN ((pg_trigger_depth() < 1)) EXECUTE FUNCTION public.auto_base_salary();
 2   DROP TRIGGER auto_base_salary ON public.nhanvien;
       public          postgres    false    215    219            �           2620    26268    order_and_payment auto_price    TRIGGER     v   CREATE TRIGGER auto_price AFTER INSERT ON public.order_and_payment FOR EACH ROW EXECUTE FUNCTION public.auto_price();
 5   DROP TRIGGER auto_price ON public.order_and_payment;
       public          postgres    false    216    220            �           2620    26269    set_table check_booking    TRIGGER     u   CREATE TRIGGER check_booking BEFORE INSERT ON public.set_table FOR EACH ROW EXECUTE FUNCTION public.check_booking();
 0   DROP TRIGGER check_booking ON public.set_table;
       public          postgres    false    209    223            �           2620    26270     order_and_payment doanh_thu_ngay    TRIGGER     ~   CREATE TRIGGER doanh_thu_ngay AFTER INSERT ON public.order_and_payment FOR EACH ROW EXECUTE FUNCTION public.doanh_thu_ngay();
 9   DROP TRIGGER doanh_thu_ngay ON public.order_and_payment;
       public          postgres    false    216    224            �           2620    26271    nhanvien hesonhavien    TRIGGER     �   CREATE TRIGGER hesonhavien AFTER INSERT OR UPDATE ON public.nhanvien FOR EACH ROW WHEN ((pg_trigger_depth() < 1)) EXECUTE FUNCTION public.hesonhanvien();
 -   DROP TRIGGER hesonhavien ON public.nhanvien;
       public          postgres    false    228    215            �           2606    26272     nhanvien nhanvien_chucvu_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.nhanvien
    ADD CONSTRAINT nhanvien_chucvu_id_fkey FOREIGN KEY (chucvu_id) REFERENCES public.chucvu(chucvu_id);
 J   ALTER TABLE ONLY public.nhanvien DROP CONSTRAINT nhanvien_chucvu_id_fkey;
       public          postgres    false    215    3211    211            �           2606    26277 4   order_and_payment order_and_payment_customer_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_and_payment
    ADD CONSTRAINT order_and_payment_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id);
 ^   ALTER TABLE ONLY public.order_and_payment DROP CONSTRAINT order_and_payment_customer_id_fkey;
       public          postgres    false    212    216    3214            �           2606    26282 2   order_and_payment order_and_payment_date_time_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_and_payment
    ADD CONSTRAINT order_and_payment_date_time_fkey FOREIGN KEY (date_time) REFERENCES public.doanh_thu(date_time);
 \   ALTER TABLE ONLY public.order_and_payment DROP CONSTRAINT order_and_payment_date_time_fkey;
       public          postgres    false    213    3216    216            �           2606    26287 0   order_and_payment order_and_payment_meal_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_and_payment
    ADD CONSTRAINT order_and_payment_meal_id_fkey FOREIGN KEY (meal_id) REFERENCES public.menu(meal_id);
 Z   ALTER TABLE ONLY public.order_and_payment DROP CONSTRAINT order_and_payment_meal_id_fkey;
       public          postgres    false    214    3218    216            �           2606    26292 1   order_and_payment order_and_payment_table_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_and_payment
    ADD CONSTRAINT order_and_payment_table_id_fkey FOREIGN KEY (table_id) REFERENCES public.tables(table_id);
 [   ALTER TABLE ONLY public.order_and_payment DROP CONSTRAINT order_and_payment_table_id_fkey;
       public          postgres    false    216    3226    218            �           2606    26297 $   set_table set_table_customer_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.set_table
    ADD CONSTRAINT set_table_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id);
 N   ALTER TABLE ONLY public.set_table DROP CONSTRAINT set_table_customer_id_fkey;
       public          postgres    false    212    3214    209            �           2606    26302 !   set_table set_table_table_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.set_table
    ADD CONSTRAINT set_table_table_id_fkey FOREIGN KEY (table_id) REFERENCES public.tables(table_id);
 K   ALTER TABLE ONLY public.set_table DROP CONSTRAINT set_table_table_id_fkey;
       public          postgres    false    209    218    3226            �           2606    26307 $   tables tables_nhan_vien_phuc_vu_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tables
    ADD CONSTRAINT tables_nhan_vien_phuc_vu_fkey FOREIGN KEY (nhan_vien_phuc_vu) REFERENCES public.nhanvien(nhanvien_id) NOT VALID;
 N   ALTER TABLE ONLY public.tables DROP CONSTRAINT tables_nhan_vien_phuc_vu_fkey;
       public          postgres    false    3220    215    218            6   j   x�=�]
� ���S�	"��0�XHA�*t���}���؃2����{$��fV}�
�v�`���T?��u��M�.K{��1��aT��F��Ǫ����
"� �.%"      7      x�|��z���%z�z
��W�Č;xv��*����t�aH�1�DS��/�7�Y�M�Z� EJ���j+C��"�̈+"�$r<�:n��{�����ޏe�F5��f�!/w�U?l��zޭ�z�M�N����u�޷m=9_�)�2-�M;�����Uٷ����ޭ��@;q�9���}S���3��2�*zٶ�5�����7I�8��:��z��˝�L�wF��~f~�mݙa�R|��G�T;Q�8^G꯾h��6o��U])k���ԗ�î���Kַnp���	�����`����M?[3���B��L��Y7���M���$~��3��r>���t����^�mc^�����&�'վ� U_�w�|1Ώyب�1q6�ڼ�L��;u;Q:��i��M�����2*�3ɰ<�]�
���ݛ0J�@��>�m�9o򶩻�+��}=l�>�7�����/\\r�=���Ɯ�S�Ux�j?.R�ެ�O�����I���7M\��4���q��I�[.E��y����y7�K���/}�v�Ox�C��Ė(���blz��M�w�)�����/p���4ը�F+T�]�s���{>o'}z���a��6�����RU[v"ٌ��W{Qc/��s+������V��i���3P�d�/x0�t�'}�+_y�K��>'<��y3�{|u���"m�6?�^��{N��}W;~�;��<��v��m��p�"��P�����a>�wn>�����Շzzؚ!Ǧ~=�L���W6�*��.����8��͜4�\�?�v~�;��:�V��6Uί?+��	vh���zg��:�1�9���u�r�O���W̫zz�V�o9�*�]V�xDC��<�x��ĥyIy���^t��$�1^~Ry5f89���9)s��f]�_\5��A�yq��qu9`����`�IAp������W�f����VG7i9��a�^W}s�Ag�&��
?�lk����O�x�7Z�MA�Gn��5��v���n2����tȎ�/THʗa{ŉ�;J"j����%����+É�Fݏ}3Ou�]~w, {3�B<-�Wo� e�b�M>�Vq�:�zȸ���ހ��@�7=����0nx"U1��M�z:������� �a
|'v� z�9A�8�L5�d���+�R�� W���\��9�'���0g94��W㫺��g��`Ş��e��������>����TۻU��油ԟ����i����Gc���4��z*a�T��z\ug��?�C��I"����s5��Tݷ���ڸXB�|@x������Rx���n���R���)�.�GL�>���#�����.Ի��e}Ȏ�X^X��OW1����a�pҨ�ai���~ޮ�v�n7.�_����/��H�$�:5����aHZ#���΄?��WZ׋ob �8��Lb_}��_s��`�C�E{O��}X��e��4M`���p�?6����OV�~�i��~_��qO�7�˖ |T�7'�S�L9���n�t�u��f��{1� ( ���� ��i�r_���۝���0��7�2���.��f7�E��kL�)��E�tޕ£w�L�p"B�g�So�my�é�vu��i<]�/�'��:�c����y�W��+��ܬ�N�������Tj�~8�@��c�( ���j���N��[��h �p������_��8oz��o
�9XA�Y;vWf"BG90���#��4(���l0���4�
,���'z��{bMX�.oT].�.q�P(��Kl��XF;�����cz���Ǻܩ�>˺��S�<47rZ|@�(B�q�S[��U[Ck���<���a��Pc��)l�}MUn���4�j����iT%��xq?��	6���F��P��h�{_�J�bO[Ioi���/�7��0/Lu�^7@
اP1*��w 9�nh����&��!P��5�p�8�|��k�E�u6��D;:�hS�����@őW��<:�{�Qm��껬?��9�Y���(�L}�W]�M�|��@)ݎ���V뢿� o�}��(�V�QC�:���Qce�dE�o��>�=�@)v�6U����`
<[��ZA�r�Ͷ�2��nѿ������ ?�k�|��V���_b�[M{�� �,�a2�'���n����V���o��Ʋ桩���ӵa!����t�/�<P]}���o��*�C66�d��N-?�n����>"^����
��Knbd��!��M"��ѱ�tFk=d�0��p��iJ�p��0Q?�~�P�55��x���+��C��pG><�����~mG+�)3e��m}�\"�d�� .�N`[�ر{�_:��.oUs��M�g8q���xL����D�5�-}�A���ǫ��s� {0�>����8�m>L'u���>>���].�:%΄��Nq~��Y��r\$�;3�!���K�n"/�O�M�nn�� u�㭤O�<^�r�FX$7,����b68�_z�];�
�,�Zk�ګ�k0� �&^��ʘ�7�^5���86���Ƙ����3�S>�f�0���𡑯|�v=�V� j���,��y<�F<s�C��E^��v�����X$�˺S�� ��x�cxr�Da�h+�9�D�4�E������;\�ӌ��&��M=O}ė�#��������2������~	PT�M����׺�+�v�X$/���i_��KpC'#�s]8��+���P.f ���E��c�̕�ŧ��␇14����>�'/���+>��\ 4C���� E�P��w�l��}k/�v0I��#�4�!���)�۟sUQ�����]k/�ʮ(�����j�����Kl�y�<U�/e�r�-Ouj��Ph`�}̏���4�jۖ{
^��M�_�\���j������:��q2����^��&j0�
5�5��S���v~�##G�ɫ�~��'1hq>_��Т���r��s7��8X�"y&�g�zpy7g�B���W?z�i8��0�#l�doC��jۜ�4N����R�q4�5�:e'��}��fC�)�.0*�*,��9A�����Qw���N�8Ń���t7q�G�#<�}Sέ�.^��U��+�)�!��GT�;l!���Xr�=U���e�` ��aAږh�6�|٩�:n��5`�3p2<�f/���]]�0�ƃ�'PÑ����a�sxw��5ܔ~����de|�S��Mn��l9/`�i�����WP�V����;�x�o��Xk9^�NI~��9���������랸j��cP
��ў���]^U@{o&� ��XE��vsuaQb9�~�D���Bx�Н���Q��Oj��e�uE~��5\r����U﻾�	T�;U����_YI��_jqZ<ő�t� ��LN{m��j��7d�1�|�:�0�_��v������y��Ԯ6�$�^�m���JH�����K×?�_~2V������Y>��O`܆ix�P'���ϼ�PͻUtE����@KV��c���oc_k���!�z7W;lW5TV��d��T���V��Zt�������2O����li��Ϻ�\ƪo����� ��`��@�j�⧿"�����>7���rq]�g_�0�9'�K��"?S 8o3��߆����� �9���f��Y?������{�j?�e��v��̘
n�����������5��Mo��"9���ove? ����|U������d��8��b�@�M�;p��@�ٜ���Y_5c�q$�*�J���|�COw6C�4q}v��?	nc<�0���'t�.@�2�"�0?�G����7���O��-����	�P	����x��*���ٚ�ǖ����������b�x�c�(�6Pu7��}���Y��4 �f��>	�'xp	o� o/���y{�9�R]��S�pv�X��pS��|�bNj��ɎpN4��%��D�l'0���ԅ����".;��
���C��~�~vA����M��@�M0�՘=�g�ʺ�����;��    �i��!Φ�]Ʒr8\�t�FU�q�v��

}���+/
'���� B�5eʹ�ǹ��*�����Z�{���6С�=c�5/?����6/7"�e]~�8{����K��/؇.��������ݣ� ����Y���!�_xhi�1��}�v�6f��9�Ёɳ��P�w��呇�3�A�\�76�\�u�6��_[�W.ޖu��(����k�7�����
]�;��� J�	5p��p�>R��x3�'`�m!k�F?�>�������ĉ���7�=Lt�{U�Bփ@���OXo8�y��m��		$���R��
��)og����-y�0���[�S vF#���ݎ� s�����x�=���щ[5Į�5�0#�b�Ԙ�����=��5��A�* /,�L�r��?��4I��
S6������,k`p(<p�a遃���(g��Hs6�1{8]=i(�4i
n�ؾa� �Z^�!��'QC��C��(f�ʿ]?��`���o~��Uwr�֬(%�E����g���o�n������J��8�1�9]�7��ں-���jO>�z����+�I4���{�� ���`�E|�N�<ͅ��S_3]�g��;}3�� �oF f3-�v��ft�ߜ�'�x�M��Ą�L�}�vGj��~���dn���h1�_rqkkZ�G�e��Zɪ�l036؅��6� p�+u�z��	�{`>��I�Y�h׽停�E(�,�.���6 �`fqvXi\F����g��{5ēT�ꪦ��iR�VVf��4E��/>�����>��ˏ�Թ��l6�+������~�h�,����!���w��<L�IU;Yu\a'���B߽M�4�nG W��xC�[A'�܉_cq���E7!�>��	�x�?ySW9w7C��Qݏ����l(���AJq��*p����+���NV�g�r�o��\(�JZ�w�10Y�Տ���T�(�.���:p���+P����(�ȏ�'�;��w�����Wec]^�B��tu�vC_���>C��e����
���ٲ��E���> ��xS�C�-�*��B�p�\4�?!tŲy!������,Y@���7O p��^t��aošV�u�hUqX$�Ͷݼ^�^�a������^��o�S��X^XA�ෞys��$p�L"���1��W�����Ss�{kђZ�S�@�Di��t y`���ﲢ�6}a͡�K:�!͸�K���m��Re)���Mo_��[]�.N��I1�
��S�s0�<N���I����]'\>�P^\�?�]��� ;J�fu+/w�+�����1-s
Uo�fn�7��s��BVݭ��j*v&aa�R�K(�O�?�sC��YA��ɐx�D�<Q����a3����\U��� ��c=]�:"<������ 6"<��s�2��OVп`��	x��>zKFӋ	R�i\�g32�E�� gu�z���	�� 3]�pr�B������z�O���F>�����1`�}�7!�1s@����@�߫֬�������/�/u�o<[?��G��#S�?�c��~�9��F��X&!�V��<ёVp���|6��󞋾_3�g�b�i%<�$rտ W�ERΡ����1+�r�>�G���qX�����,�W���싗��% ���u��X0y�|=	)�oeէk>�}�!�6�i
1�ٲ��z�s�v]��k�����_��nc��yGPE�l��|fx��BV�%��/{U�3&76�O�
(U�d����O���9�z
�u�rĩ���"�"���̣ �a���w������x>=����f�;��L�s������s�����~Q��N�7�Z M�^���x�@A���mNM<f�q̉͟�����ӻAV/����0��n)���H��;��0Y�z�s�P� +yѵߚ,,� ;;�i8�a�WfN&�2����P�dL�'-gًp�`����0H՗����=IV-�R5��^�ջ���z�� V$��>�I�\J�lڳ��12��� �qF�=j�D��K��R[0���I�Ҿ2�x�y�u�/>�Qs_wΏ�dU(��
ODEi��C<���9����Obq���Y���n3W\3�sl8hc��^�~�T1HƬ��p񪧔�5�s꧄��4@�놐h 1���k���W��0ƥ�ѥ@�.;`�]����
��|�Z��d�Q-�o|�W�2�JQq�}�'x��`���m3���u�$������p(��UT����4��`o�\�%�1��������lw5�d���=��2C�?��%�HT���q�m&���zԦ�O�N�dx�yu�Sq��x�z�@���@���:N�>�ۮ�ox��I6<��%M6�c��ؖ�=�.�-W� ���Å*��P���I
W
 �k^~�$={b/��f��������S�������Y�����J�r+x��������?PvD/%J�y��; 
<Ⲵ��g�W/X�[w3�0��!|I��r~�����w�$�@��}ҕ�o"�4"��Cf��sm�I��x��y�V�����ɴ⻺���o�Z.�pR�Zӿ��C���c=�BM؋�|�&�W�����ǅ���ʟ�[������!�f����ׯ��x��$�����it�]W8�*/���x�L�O�w��d..z� >.��Q�!��*k�շq�W�9�\�4 *`�"H�*�F٘����
Af�����-��lJ���0����@p�&j�.R�u9S�y�5��ΉY��� �yPDq���gFa��п�H\g�%��ߞ^�g<+�*8�o�kNv��&'~�k�B%\�Q�/�G2C��:�I{&�K�B����#l�X���P��w�;�dT����;���Y��Y�& �|�@A�a��|9Y!ώ��,'|�(�Ќo������N��X����{a�P����,4@��;r$�;2k�U,3������9i�T0
�o�"�g3<����R]�	����5Cl����:��	�C��hH�wU?]�fM]M�B�0̸pXE��ߘ�1���u���\^DI%Ѐ��D���O��pߩ���H������h��[�щ��]�2�z|)�u���-��.�8l����5S׷1.% �Ϻ�TH���g՜��)���Oߚv�%��@�� U�w^۱��]v`�FS]�W"W'���X�w��͈Vc+���*�_�;Y�<�݊�_��?������F�od��j���4���C�
�P� �W~�������=Z���8�=fc�-�]F��i��qJ��J������<&kD�w���C�ysh�Qb�e���K�����2IJmTjq�vq�j:����7�1ٵU��".'V���b���ibcS}�7�����!�w?�������:>��_��I`N2�η�?R=��0duY��^ٝ"X,f�2�/��Y��]�5��d��:�Z������ �Q�a�s�k��7�Um�]���rN/�+��SF$c��D����m�����k�$�=��>3aH>�!Y�ln�iҐ�g��Ņ%�
	fh����T���=4���Tq9^�����`�p�]p ��zQf+��{U+��.���	&ܪ.)�\�1�=o�E:�x,,=-�E����?w�ʝ�}�����zc.Q�E�	2,UB7�/�-�q���a������r�`6<l�4��R�R��l E����Ύ�sCKqA�F!�Q�k�����Uq�E{/g�V����K�T}�[	��Q������~(�xqv#AR	=�s����Z�JB���m��^�)��c ��HW�1�����|�ì����y�Q
9B��P��C[������0���5�
ο�(��N�/a�:O3�ǔ��;`r�[>��t|��$7G�6\`!	x��~yYc[ �pc`�I6�OC_^$��4I�!Q�^Щ��Ќ[ٱ��N�����r}ѓa1���NU-gv�S׵��<�y��➌    �4�p���K��og��V�E6�g�6��]ŷA�������_b�H�P��.k�.�gH�Hl賮i�Y����	��/��pPVj��q�\�8��W�M9tۼ�Aoފڜa�j��@D̾�!��_6]>᭑Q?ZAo+�V=�	IϏP����&��a�v$�)8�V�[���hd.v�"]O���O:����Y7X���3/
F��d�;S��n|��3�	vM�B�m���I�󸊺~�\�@7pOJ�~;�Y���=}��t����
�ot�����9������w5�5k5lI�/9���cc�mM=����|�p�G'���On�
��,��Xِ60S�,��۴��v�`ʏ׊�Un��!�<�?�I�q�¾o6�w�"��2gͫ^�I0%<	Tt@R;vP�-6
��:�ϊf6��̮?�M��)-h*p������\�!��ݛƜ.���"Q6����v�k��~��M�����+��=t����S��A��9�v����?5<��*�'Ə�6 �N=W}��r~�8ԒZZ$=>K�F��Ji{���8�l�8��z�Hs/�V`���U�Ԇ��41��=�c5��^����|���H�T���8�����yR�"��Y=q�|�x�S���ޝ舼+�c6����T��0�5 �$���I,L �����,�-�{�iH&�g~�G)�$�I�
+��5@
�b���0k[��|����5d�]l6f��	������.F��n?⦹xn6n��t�]2Q��^�bC��gq�%V��JOg9�4��I���^Si5�_,\�[��%�Ȓ7}w�+CK�p�O����`3O�ږ\<?���|ə�����i����kqK�����y�S�Q=H�O$�7�����XY��rl	J���H%7�I�t|�J������dة@/�"�{o����EӰd�h�l��Nr�ĽV� 4��m{��R��b��t���?m��;�*S-��\TG�=_��qB241��<����d����.��tHEBO} ��������Y��aL��^��p��d�D�[���\�z���:�+�/����;NCϒC��F��O�ި�?Y�p�w,�X�1�_Ǿh\�V��u�|1�NL4V��`��SÒ�����E��L����X/�Z�3xf8dM}��7t�3�z��H�<���pV~z�"��[�F������>���|ћ�
�v-�=ǽ�%$��t�UGiLB�q����e�w�Y�v��}���H�\�?Sj�������ÇaI��^}Qr�o�F�7N�p�$}`1Z.�E���7.i�@r�tJ"�V��o�K�;�v���/��������0f�����_3]���_�v%�W^�=�*m�ݻ�
�6�ݶS)�KA�NV�}N��������[�c�kh? �1�{��|��S2!IafgZ����5�1�^����y`��l�xu,�U���~h��q^�C�yn�E�O���5��&0��跄e�x�ɱ��6/ޯ�V3z�����	�#:�����e�Q#@f���b_V���厼v�����8�n�|�Ն+���(?fڗ�3@�{v)�@��ꮒl�Y֗�~�""$��Ƹ�Q��d���O��"yY_vW�\�5��xA��"��X��n>�d��d����h5���t.�M��m�b?珊�L�K��@Z�5>�7ޭ���#���[��.�n+�V���;�rS���KK���+rpS����G\�:�\�������䔤̋�]��H7z3��Ca�8���/3�R����i��z�r�f�¾�R�Um�E��+b�'�%���r����6�(�j;�h+�h���O	{%��O.�s/k���ʙJ�M3����%c{�z���i:�})k��<O��Uo�*����w)��O=0��?,R��G��"�m�H���KͲ��F���͸��ړC/�rV��ۃ"�� R�7 �dfU/��
&ې��@
o!��$�EQ�ni0{�ܠ
��b\,�%�}�K�G��!cr�� �liaN=��p��-a/�BH���\���GSL��Mr�=MՆK>χ�%,ſ[��w��	0��OD�I�:<Zf�@\0��������8R���Y���ez�h̕�d�-$��gĎ�W�����7�é#�۟���T/�.�b>SԞ$��x��{ԩn�B��C~ņ�o$P�Ί 
�x�p0��
p���������B��h,��U��D��6@,;X��R[�K7���9^��"a�l�~Rw[+�/�N���Juj2�����&�\,�^�V8\h�6� b�Rv��}"G2�ګ�(ݲTw<˿^���K�)�Q����N<�j*d��Tz!#�.�=�W���2~�M� yM>f��R�"�95���O���c^:yL���3�<Za��zz�bɡ��|Ց-����aOF��Y�삤��p)�峣/�3���`�!�W%W���gw5.��p���Z!��:�A��O�"�S�1p,�f�����+~�Bjkh��1גI����I�e�}�K���&I�<J��U��W���V�rP��N���јπ��@�)�1��rbn8f����Քg�!�۰��s��M�u1��ʴ��θ߻��v3��1�Rj�$�Bx��$w�"��ǓD�x�B'���U��%�x��w� #C����>Wt����a���[�"�R���.IǾ��U��0�Iu��$�1W�ZB�q��^�&Ł$�����R8�<krq�p�7A�����o�z"m�+�; |YuxM�{:��8/�:�lo��U[�]]�	me,_�'~s���ir`-6�.H�����%�p�˄c���= ��,���^����ZA'R�>]��<T���T�X�5�4�2���e��,���Ͱ,�8ƣ&�YO��!d�塦;��Ktu�-��\�$i�΋H[֛����d|�Ȍ��Ⲣ^/�y�$vƷa����u����n�d$�W]2������&���Q�O��'�b�f\I/�]u�u�j
��{�����[Rv�0#��0��a�d�&cY�3 -Y�����$*�y���H��,�ޜ�w��?�s���z@!��{@9�kI+d�0�2��f��G껷t�����Rr�0U�]T(m�}`ջ���z��̲ǡt�&�p�+yچ�������l�KtʃGR�+V*a�:���]��
�.���/]|Ҙ�DMA"��5��Gg����_�#��.A	 ��Iě�i،;��1��1�c#5O{���ى�"��)�w������]�H�S�VŅ��kH�����
_
�F��vkl�����Tҭ>>�:NЙ�v�k3M�}W)g�U��6�S�T��8v��ޘ�}3delY����<��&UI( ���(y��,�I�ʞV�q	#�ElӴ��G��w��z�j'd@(��[R(c<��P��9o��H\oJ+���I}�5%��*�8�6C�b����#�q�h=ecq�q���!4�G���2��IF�1s���E�sv/�-�yѨ1�y�K�����V��`뗑�fka�R�nIm`��FFKY5�Kq>QAIX�L�5��g���y~^WXA��&&�ۂ�-@��$�"�(V؍��?�Iգ����[��2#�Іd��oI;���7K�(��+�u�"sH�N"3{��t�x�;���
����'��?�V^aVB�@���?����?=�s����,l#V�Jn.vտ<Il�3�#+��r�,�r,�J\��pY��JR=-i�f���H��,9��c=z̕�:��N�D]�Ǻ|Pmu����o���K >`)MH:���@���ci?զXE/|��Ϟ�-������K"��u>��W/��n6X���������㻪e��g\�xyg)S��<��è��Q����z����r-��ƞ�3�L�KV�?ཱི�{=cԄK��$7q�@�\aa��a�~���+�`�GtC��Aơ�ڐ��t u��҈��Wd    Ӟ�^�Kn<�l����'��� �C�����rUf�U���g恍;��p�a�p���[�6"��L�^�}��f�a�R���d �˝4��7��x&���/w���H�X,Ϧt,;��R��U�[Eo��V�'M|Y`�������yP���j�Ud"�y����m�T��whXt�7?cܬ�'��G�d�����໓��'��:t�H��WK��EA�z�a��+c�{�`�ً���ِ�wwY.�P�mR�5�°]P���,�Tꮷ����~/�ϙ� �	 iM���7Y��pԒ�=I��m�	{���99_�~$Q�&�מ�.�9�b���*�et�~h,��ڌ��u����C�ey���X�������@�c���|R�1,��y��m"��0͒��b�j ��@��DR�U�H�ta2�#�5r=al�����U���J�s-�
&�%�V������^wS�������.����Ňl|N�����aU��n6�r�Ks�fI�J�e°~��Hj:?ۑ��(L~�u$d�j�6`4WX�p\ ������e����b�,���X�ZzdH[ ���}��n�tN�G7L{1��GxH?sϤ�T�d����.���R�c�&,&�����PӰɱ8����\c62�ǚ2߷l:�u�Q�#cMfZ��23�Ϗ�@���<l��q�����/�S��P
���f%N��G�a�H�h��G*��%��a�(%N�>OӖ�9�\Jҧ�%\z��V/���	���{�4[�p�a��x��T�t�cf��P�9��_9�����sK���ؗ� �l(��s��aOB�Z�|,�8��p�8�1�\hvsb�ɯ�י2�ڲ��B":]x���P�%����I����W}+�!m���p_��H� ��]��\�͒$��V�\�ڬq"|TS��\j�|���R�:�E�f��]��G���ݾC�3��b�vY����ˮR��6s�2Ǐ�o�k<��4�P��wpA�TX)㱲P+��K�ù��˹[$�#����M N�9�w�*���{�l��J�����x�g�/I���1��s����G=�S��p�<I�´�;����ø�m6�2e�c�t���	v+{M>JX�F��vn��~� .e���_O��(I���R��)��m-��0�G�)��N��O�&Rj^�� �ʫ_�	$���>yK����)�����l�!��Zq�_�+���M'�=˷�ئˬ�;6c�X��~Wc�/� �J�����"�*��KL�rlj��毸�لS*|��%L�Zd�Ew�v��>�{�?�iKv柮���NL����(ԩ����HE�F��:_�2+9��vl�vHH~?J��?$")s���I����L$7!�=�X*�ٕ�#o��ٓ�����^Ι��]`�1f����IU����K�L��ٹ�B�R�Ψ�a���!��UV8��o����}��L�s��1ۊ��؇���ҧӥkT��L
�'�Br�>N�~�U�Wyk�Zvοe�2u�Xz�-�2���5����t���R�P�L���
O�S�;�E�ޕ�\�Db�������e{��ejPid�~od�/���"��K��K�,v�{=�>�s�AF*	�U}���	e�&��u��2���/��0�+�)̏v�ZK;�D��R?dz��@o�ʊ�����GU"!��r��%렘;�~^�����t�m&I�tk�l���������9?���	s�ur�
��g#�@���'f�yͲ�<�O�fB�.���KI���@�M\�x�%c7���kǦ��z�
����HmIN�Ml��z�d ��#�kSH����pŶ���߯�G h����ZQ�O�T���=RgR�~ M(	>�w��JJ��"�*˫j�����ri��2���J�K����hd�F�]���G�e��>hW�����.t���Eқ�LP�t	#��hӏ��� � ��V�ۋv ��ݐ��Z�оt�,I�d��͸�z�R�<Z:k$��e|�§���1�ƶ���*Z*��"]/\-�.�( \��r���1��Wmi}�d��9�Hm'N[���ٲ����I�7\�>�A?��`�SrC�(�oS��}�\���}>��HE*to��M7��-��s�y*4iF�X{� �$��x���pϲn�5��+��ȓV���k[�׉}<םp�[�_����Ū�y[;��N���cl���E^ud�r��"r���Q�W|Êb�L4���AҦ�#Ci�(�>d�i��m�Op*��<Қ�8P?���kq��fd-����O�=�c�P"Zd�1+�2�j;�ff.��AV=ko~X��:f�J�
���E�c���
+�1�>C5�F��ƫ#���"��������f8K��ZE=I6U��LZ�/���"K�����茶!����VY�&O��5~^&Ȥ�#b��Q"��������Նn$i����4�ZZ,�	�������ߏ��D��;M����6�[��$�ia�����Y��u�BV��E��c���2&B�ۚ?V^�Ұ���DЧl�ni�(i:Ɣ�ψ��H�1�Ҝ/}��"���������,f�}�
i�T:��_;��vi|�ϣ�z)[f,��  ��,���.�yPtΰz�B��C�XE���b��m�pp>�@�Þ��='�Z�[!�����/�S�ε�[���/�����#�a{"(D��엚~�@�tG+x�������(+	���-+%�p��^�R�F��W������2V񍡽/�S��*�Xxgɋ>����逓�WRA������i��rc��� L�H�|��¶.�K���563/�嗥@��B�L��8&���ֶ^6����з�H�dY6��P��Ǿ"INm�V��'���چ�C	q���3��cg�,f7�^�D�IܞH���
[q�kY�'��U�d�ʌ͔�Jv�=���+%97Lm�C���Q���ޓ���ߌ-M5	#�q�h��:cp�B�3�<nǋ��)�̍e�B�4|�n�^5#os�w~����eW$YuRqf6�|c�l���
��z���Ҫ'$�29Č~��?�a�sܚq�]V%	���/�)�r���("HbaKI�ǜF�/��՗�kV�FR���Δj��wB��wV��u��+��X���t����d������?䲂�h+��)�4�{�����8oB�wV`��u��93�[:��Y�<�!/����n�m+x-XS\�tC�`.�.qКn��Rt5˨�����^*�F2�"f�]���r��Y�1?r�@'�9�u��B��"�4	e�	�x�_d>�r8������Jld�q6�c'�oy�|�h��G�R�~e�x\G��Nʲ\�,�ς��!랈�����/�Bӳ�d��8���ɤ	',x��,{c6��y����҅(�J�DJ,��dG
~���X�`%o��H,]ҙ+�U�/���R�幬�|��\���ea�`���`�gh!Z�r��g�0�eŹj�f�C�&F�%�͵dZa �P���w|�_�7�,�0N�H���GÝ���x���#_��R����۾�.Z�6���隁�-�.SΌ��nʹ5���t;꘻f���<ӋԆ%|)\l�@���/����dK�{1�m�υ�
,��s� 38?CnT5�|\E_/���ҫ�[[�ý�	��x�yo�m/ͫ7�|/��9���Q����"&�G]0��N�L���=�f��A�1�k(�O9K�����ȹ�U��/�!�5McċO|[��֗��lN�_$�e��
]�YdK�w���D���R� �=��%�Ș�O\;�n�-s�|�H~�8��s��QL��}�_�Ŵ���a%?��Uq(l��u���)��K�(R��e���@�����_��e/']b%�N��'GE��Ѩ���ϳ��u���pj�K��k[����o�վ��/^,T�Lև!�A�H���g���$V��'#l�\0#�w�̹��}�"����B'�z���
�	�p�>�5���|#�C�    .��h� �}�BJ黾eE��R�Vٲx�K��B���H���`RI���鴳C����y{ˍ��5-,#�m�_>:������.~�w��r�R�J^��CK�)q����
+���.@k���N�k�6��A'��*����u�>^�Z� B�
I���Ӝ����NV��Q/�x�wqD�릒L�G��bW���o^"aw*46�'�Nۏ���:��l6���NV�}ю�̣;�NUZ3�R;��Y�+�V����V޻X�7�&���p>�i���ʭ��ɰI�H������ݴ���q�1���v����<���؈�����Z�r7��s:rC�H��,o�"Lү���\<���܊q��~��e�W���z��=�Ϟ�_�|�N�@�=98֋菙����&V/�}٫5��a�����e�;X~r	�����ٷdi�����������
��,w����9�d�,l�YfŖ����F�YER���O�!�ˈ�8a�%�gB��[(�_Kr�jۧ���|!�/�Kh����z+QǏy=��o�>�!\8��^?1yӉ��̘�@J��W��.�z���Z���O�'!��9�P�{���\��x��J�:-�LAR�ŭp���G��|��x�B�^�tX����yO�<A!Ð�]K�|I7�3UE�ӊ�`�La�?��n���%�Oϐ���So��%�!��Mcb�_f���?M���g�_����U��23�rh-�D�i�b�QR0���� ��Ӻ�VV˿��ۭb]�v��٣��-F�_
KY�C	��tz�$η~dՎ*V��8�]Ѯ�H�����($9��H1){�Z)��n�}}u,H=!��m>̧�k_�q���$����eɸ�'%��fx���s��b	���c僊!��ۏ�ayo�f���b���sJ�W��I�]�@zGN!��o�E
��vH�2������\Ni��%�Z��z_,RP>��Y#��yYC#�� O�.��I4��Ŵ���ƖJ��+�+ɘ����]��dx|���h[f�k�߱t��*xˉf]�p�"�g���%D��:b&��O$��q�-7j�B��Ⱥ%��QKĀ�r�u���fL�p��`�Qʀ��@���Z
���|���^�S?��<��T��܅Q,}�}O퓑n�?��ު�$kp��A��$�R�f�����72�C;�8U����ɬ��e[!Ӌp��L����qNj�d�l�g>���:NQsxG�`�|^F�|7'�8���9";�Z�����w��#Ԁ�EHG�A��Y��t?5�o;:T�GR^_�V��~�kW;6b�H�	s+$鐡.EҌ�/e	��]�4����0Ly=�L�v�5��m.;�ڐe�J6.:x��;�\����R[)^,\��� F�(�I�e�k�[�޶�	��Q��X# f����6�Z���e���tz!J�5��I C|O}���rߌV�js�e"X�4^M9���Ifu;2o�g6wg9���Fh�&�Ƌ�Ғ97U�[�cA������&�zt6�J�3 qL�euV�ԅLV���7�cx%Ѓ�ƨoĖY2����[F�y�ъ�"���(��������el�����,l��!۶��gX� �Hr ��n@�r&�T�jۜ��͸�W`X���Yq|�����a��Y!��M^l�W�F�n�Y�0K��~��r�����J��eY C]-��e�Y��ݬb�_��ti�E�+I�)�~���Y�#��
a���uk���z#~|m)�fn86�����Ｅ!u$!s�B���52�����:B�Wa�ӥˬB?ať�����,-��I�0~��h� �v�/�ch�9���U�s	���:֞�٥	�  G.Әy2w�	S6���L�W��^�� $����I���#�q��ȡ�V"xD�E��xi��a��� �B�尙X�{꘹ak�椎T���|I�˙f�96L�9��/#3
{��B�c	����dް>�2y���(	��=Œ?�B��cw�͘�b	��$J�Q�O6�TۉK�yV��-:��e �r��ǜ��ƭ��մ�3޷D>��Ha�J����8'1�]i�p��FmF"(ֹ��������%.�E
�3�jy�H�UR�|�G?��2c����w�]Us�rť"K��|O��^Z�m���p�LQv7d�y�t�p��| e�?Is��`��yi$c�D�9�"����%���B��e�ZY�VHO��z)\#E�o���ؔ���9��������KN�3c��8����K��}}8 sr	����Թ������4.�I��B�S��Q���v�������&�d²�P}�������m�0����3��Z�L���:�B���jx�{lx��}}�k8��,Yփ�����d����o���e����!L���+�dw�� �K8e#,O�_��񥑳�ە�]1+��#4��/Y���᜙�ח!)Ǳ�+Y#G�߳��]�Yp8ê����?�ű�����x5J�X�#�p������wV�x���4Ii�ŶLl�s,��Z���p�;+�����PL�t���,�a������?��8���)[�y���ܞ������ c�Z6�>\��V��0�BE�nz������r#k�^�c�%m�dJ�k�>J?�t�M.��_A��pPl_��� (�1���v�1��R��y�;�hI"a+�}��n2vX=S@��P��'��d9��x|lAH�V^�#S��.�*F��.�2"`�3���gm���6>p���Jc�R��+|�����O��h��$z�yRt 	��b�삜J�K��WS��;���'l�uVK�Q��LR��<*V@���Rei�(�X�5��։`�?
�Mٿc^�6Ϩ���Ϻ��k�TPr�h�
�a�c�Ǆ��A�(ZX���5	SKI�X~�Jí�OG��K�k�xg��~��9TC����pr-:�-3� p�6�Ԯ�l.Qu1G�r|�nF�	�DZ}6M���a�f���
�yJM�����q�1{[}�--�9BK�c�yҌkUl_�P-�,&�Wh9o���Yb����h{]S.�Ql̈́';F��E�p̖�����.Нݵq���9*�E~�L���Z؏���� #�1�3y���7��1&�x6U�=�R�TP�i�Y��gV.X�_3�C��>�|�s`)�N�h���EG	�qj�l��O�g3�Y3���Q�Ǧ�=��C��FIJ�R1q5��g<�JQ��}o�z%���uYYB:��meOb��
Q��?�4:�k�i��(�T��JV����Q��Iw��(>��)�/����TdL�F��vQ�:���-��P���0�`����яѯ�L��Jy���ˉ�>��B�Cs׍5U�)ౝz�ޮ�t�b;���I����d�ΛzA��b����(��,
��M�HU�s_h���FӓG�� �i��Ra��e���_���xX�h������.�u����^�����~7G�ĕ��gzMa�w+x�4��j�VگO��9�V��/̽�}2,��q p� g��7��?v�b�;c����F��S���#�������+����.�6��ql�ʞf�%��ta_,)�0T])z��<���Y���ձ�Ieu�&@J7��X�U{'k�f3�in.���1�������[�otT�fc}5����4�g�ՏS%p㻝�0��޳����0Q�8��lq\4#�?�F:�q �*�~F�vs�!�e�5���em�VZ�����n\,�I#|`�.��C��w�QۙK��t�rLn|z�^��+��ȡd(�:��Gϣ����*L��nJCb�;~u��M��i�t���\V*��$�W,�.8�c�d���r�t)ҕt)e1�ǗY ��p)'+�鳦��������R��HĪӏ@X2Ѩ�.R��v0W�K��tGXa?R�w���X3����q�&U$�L������;������ܲ2Ems+��e��_�1��8ޗ�=��2Qhڱ�^+k\e�    ��ˊ����4�O��I�_��?pq��g+�&����N`ɔ,�!-�Dv�+��8�K��p��M6��#|�i������m+�U��0F&�E���a��䤫h�3ih�P/I�R�xw��~�/3I�V3���nrx�I�Ύ����a�z��2�Hw&u����Q�P��z�3�K+k�2���6\	�M�n����K��'h��{�w1�_4��Ib6�q* B�䨜/��o��M�,ӰiկK�د��G�9H��i׏�}�dE�m�*�d���Ģ�.����g"v�97}�wj��Ĝ�q(.P�v�] �C�N\R�Ydr��
q�4���/��  p�봹o}#L�=,R|�N��|Q-�������&;��CKp�����jti;��d2V��'�!C  t�|����/��BPt��+ŝ�yn��w�����ʬ�򎱝���E�K~m�K�%��2�+��aو�:��1��Y{���!�e�06r]��z߳B%�;�v���)O@T��ԧ����Kc���9�)���A�0J�;���05������N�����*]�[YG�K��'֜�jb;�B�����L9k!�*���l�Ą�Oݕ��-S#[1>=M��e��z��K�5�� ME�`HY+�χ��kgNc�O/�+>�9U�F��}�ј��.U��`q�t픦��_s3I�]G!�O�5�Gf�f$}YzȨ#�����/<��{2y�zс�Au��a�NL����`�Ŀ긘.�$3���d�6y�w��λ����0o<o�!x�S���c�o�z���IKQ��f�E:�!|�｝ɛۉ�Ci�$ʊ�`�����i���f%�4D��l��L~��!+%�S�hi����6���4�� �CX=�]�$y,�9'�R�n�� __�iں�w���$�.I�����p�$�-��D���*tRr6����W3b��	�ϰOS?eE�R��f ��&(I���_�B�X��~��p�H���0�l��y��S|k֫��YNʗI��4�m�H����p�/=[|�H޻k�rReyQ2x�\���(�P�'�;28c�=~&�|ۍOC��[�nwe&��0����%�d h��؏-,l,FK� c~:��c��]�
�~�B�� 0�v�k���ZS��?`#G���$����*��y�0H��@�ӑ����**.I}m�m�@@k��"�i���l�4_�䎑z��ڥF*R5�i.vܟ�{���d�l���H��4�f��e%�Y{�%i.[��!�\8ڽD恑"g�_X�ؑ1�5����\���k��|���OׅR�c���K{5U�VH��j�t��x�M ^_22X<�X�>+zF�)=�|Ni᳅���TȔ�����S�L1��b�lJ6-�o��137�x�B��zP��%��	��%�Ҭ_/^� k2d[ӗ�T_�Fi�̆�RH��Z��=�o�͠�
+$��PN���N�w0-B�qr�yd6IQ<��LO;ƶs>��fYC����B�n�j0�&�uR&X���0�Z�0	<�G�ˋ���B5Y�VH��n΀ٿ�X��Jr7R�{�k>�o[.��%��z�r2�=L������%�Wg9�(�y#h[r��Ш(��0�$yxX}3����H��9y�R-�X�$X��үl�e�=靭��Y!yx��?^c,���Af��;�9�]zf����{M״����b)��W���a�Kn�Mg�T_���(%�]<2Udp��b�.�����B��C>�#ݤ6"Gv8EDG�20� ��a�%�q�9��1ID��I�:v~���v{r>@��+���Cg}�@��R�Ő���s�e�4�Ш�2�xA*�kFz�X=o�}�#6��"���ek��䳳6�Z�7�� ���CM:�"��K���Z9�f�l����3l�:?Ԯ�5M��6g�izþ&�$��L����.i��w�>(���3J�_}g{"���
.i~щU�|�ɖ�F֮=����U-�fTg�,��'���@$&�F̫���#��t��*c���J&���ی#$9�fH�x�\��ʴ���UoL�.�F�s[MDs3�Q"�����yqι�5���n��0�����HQ����*�8�F״��u��A�E;��_������5�;��%��C����
��4�L��������3g_� ]=hjŶ�*����-�����)m��U;���d&�}��m�]�{6���0A�Y����l��P9�t/��{^zWT*��6J�{Cg�KD�CJ���C�ٗR����	���l�lr�1Jշ(U����� kQ�t�� ^�eH���q��G��Q�8m�5i�7����4�R��T�3�m��QkcM�[S��Z�!��>���O�jG��;�6�Q��Fi{?�0b�L�m�{SI�mZ��RN5���[4UuX�̦���A`_�y&	����Ժ��[^�ovN���.\8p�G�-�ca��%����lV&H��_�7�9�h �Ʊm��9g�$��p��,7q:MRF�bۥ�����'�ufd3��P�� �C�y�8��Fh���- :9��P�A	��3P��1N�R�O�qǠ��O]�o%˚�����tM�������ٽA%�4>�_�$���]9�\�G;�\�azZ`Z�����A��7-�Ӷt��r�/�����%� =K�"��ɞ�:A[�P�aN�I{�oU���-uM,��:ˑq{2���r��>�F��Ό��4��:���t���K`��s�Pɵ����v�䮜]o��Y.y�_�SW� De����_����߯;|������-�-��k8b�R$H}h�����7�F������R@B@��~�)�ˤYN��Q�=R �D��)�Po��<���To93A��N|��j�����'g)�=�{�k�������#�%������V`��я�2��Q.�=��KV�V���� %·%(���E�����v^�e���!|uV>�ʌvZ�6Aߑ�=�6�|��ySр� �e8�Vr=�8� ��Q�Pfd#�y
qi'�M�����0KoM��5�����J9d{�_���ofͲ�TQT�ա��U=�OI;�j���F���:�
a�@=�f�6�e�Kɤ|'�lc�,�վ�m��s��y����cD�25~q΃	�BԢ̛釥�!�sh�zl�� g�űԮu�ʇ"߳$]�S����ZcSy8l*M��5�V��q�u7����Dc�H�0��V�Ս5s6E��%�������S��2��`!�\�?������M�mn�`f��'Ti�%�_����^IrH�ì����̌�C��MXl)�1St�K�l�:�!5�S4�i�G�3����;����h�����Z���?Gg�����E�=��~��E��-��!m�"=���A�-�6ʚE�zz�6EV�rl{�Z|C(�^�Za���Y�	���R &�����W.�wy�$u��f��������&{ �u+�o���gs�3A���Xw-X��Q������"�GK6SK�k��i���@�7"��UT-�P_f���Ք�f7,���x9~�#�E�Iߵ��]� &�~�����x�'�G�+��T������n ��K�ı1�|׵�P0�P�����qq�zF;��8]�0Gp�1KUdU^r<�P?� ;-�}U���L�$���W�g�g�-Ԯ%��F����y���-�?V乡=�t�۾it�~�3�wŋ^����1�~���>����mj�٭�0�<tg��I}t#h5�q��<�r�m�r�������Hǘ�Ezs���=t����%�,˹�6�k9rITI2@۳��3S�:8��.���#��18L� 1�������y�v�M�Yc�2�3�ni�ɠ7�ʽdU;���_�_��z��R����PV�����Cz���hLPͣ!�z����ј@Gc8���U6��*-�G܏�-�o?�m�q��1��d�R�u��b����.n~���`����L'#�}@z�s�R�e�x�$����9~'P�y���eu�
��J��c��L B�"���F�&�Ṇ�'[-7��̓��m�Lop�4foR� �=O t0k$%��tv�F��]7%6�l����`Fr�    �� G�K-�w�'�CO�
������:s�7\�e~á�~����U��1Sn;0�?@dgK,��ɮg}6Ôc@{�Wj�ER�r�-���e���tN���=��G,0���h�;����]���	�h�S��X�����Ƕ�m�����kfl�2�,����$��엮��w#_���Q�MF�����8����Q�,��"�\V�y����VYC�|Pu�YvX�l��A����/�S���ċ�i�6Q����֓2E���N*/�6N)!>@rV������3)x:g�d�e}�>��q�����&'$�Q�,�ESO?*-,W]�����&+ �']H�����v1��ec� �t��������Z�-L�6���;ǿQ��K�K�{)��x�c���u��r���2���,c��AU-)7읿J5�X�u]>I5�I�s�qdlx�h���炂��:�e�H��KR��`^A��#�ES���r?��a��r�O����8�}��~)꫃�e�ʲ~pv+]����x�q���$����X�}�1�з�����uЀ-�E��=�i(t���]��\�En���	�r9�� V�NQ�r3:�#Ť��C*�pM��=zRaɥ�:Fd��U��c����ǭ���@R�8*����~~��*ű�!c�%�)wZk��SG%r�;�G�]#�ّb��|~�\h��-%�IwN�/�'W.e�κ��I�Qv�ѥJWr(��V֬���뚻� O�F�L�O�9���D+�p�R�y�k��P#�&�E�*��My$e�.�E�(���LIb[RD����!�3��(�'�(��$���m!�q����*������A�<�	Mk5UT���\���e�i� �%��Qb���A�}���f�:�kݙ ��΀�N���N�p[���+�h����t�&O���t�/L�@���z�c ~v�1�<]ԗ���CC� d�c�T�vJ�d;9'ikml�gw*Fj(��v⩀�&�����+���_�(_Nyށe�D��	Ç��kIŌ�C�k�O��i���c$'ގx���l�æ��96�L�ڝ��?L�]�,qD�����P�
�./�N"����#��&,�P=�K�74�WS���q�Ah_jW�����Z7ښ%_/�`^:��I�qW�l��a������]�͢/We�O��G�{8*b��j�$��Z�ʃS�tͫE-'��V�5�wH)%!�S�,g��p!�����EV:�	)$m)DB5ٺ�~9ֹ< �yc�|�P�
n�[f'�c�= �p���FB����s��b{\���h��,y����!g;9�%o���V��&�<�� ����]�ܡSi[wi���r�����b-]s=����
�ŋ�=� �n��L3�UK<|*Btg���Gjb3�n���f���0��!�I)$�Y�s |%3�%�uH�#��M��x����Z���A��F.'�w�@�� O�?��yÝ�����`��ˮ�(����JvB��1�XTH:�F����l&&��p�#5�)�_�>��D�m�x`������E^v�z���`��(?���Vq���-������un��L��_��7�:�������4�
���dߝm���W��>`-=�A�M�H�ꃼ���oJg��(��G�joA�I��`���]wR��?/0=���9�U^�R
9b�O૑�TJL�-s�TƬ���6G����NN��j��3R�;��/���}���fA S>���)>p�;kЦu��aKۤe��R%	I���0E5捔n�K;0
��HE�h��@�i�	�޶����ɄE��*�k;��9��U V+�ٛc���\~�E���7Ex�
G���>C>��>�q�f��:k��o\����^��pN������I��e��HN�VO�g>�ZHw�{�����*'�"y��#!�|�F%��*�����p6�	��ECo��q�7^�06��좞x۳	�l�n��v�S ɍC��yre�*�J]?6*���ث[�f����0��z�zgb)�{�w<��Z�?}�'�AE�=�� _�~����F\D�0!Ǫ���:c������K|��FE�`G��G�߯�/ʷ��F�}����vNs���jj�[nNDwF���<��_��/=�:�f�k�����uY
��P}p4;�c	~���3��=W1������ >��oANc��ߺ��FEue4]��H)眇a��q���x���_�ۿA��"H�y�����[��*������ӆ�n�:��}��I,��d���� ���Ag���E�XW�MWt7ǚ��Js<�<E�"#��25����f���@:�&*��yXL���辮ѵj]�v�B����PTx���Rk�?�S-��i�k��+~W ����4���}�G�@��g�n�0��%CΆ#�rkÂ�Tef�4A�4�of⇆��)W*-��G��p����u-������&٬d[~D9)�#�"�6�s̎��5A1܉Q����?��|g�l{p�	��+Nf��G�aR�U�N��7��k�	�#�^Ix���X�Z��i�����T�~�kw���ݲ�Ŧ�q��%��D��9T:���
�}B�A�Pg��Qq��s��Ɂ���>cY#r0�]�Y�M�k����̷EH�(!ш�c���%��oY�;�N=�Z\U�>N'�J�K�dS>��5�E����,��t��ه9U��o)M�&Cyh_��0����Cz8�����"��w��.��o/C����Vd��)��0]`]$o�(������|Η�{� M,���C�U]�Q�}?�R�W+)�cX�T1r2�b;�dP�Ov��ЬF����[��!�~'ld&"\�oNU.��<�7m�����p���{����U��f���3��7��YcXF��������@I�����A��)���m$^�D����.B	�O�p�����88�J�2���d�L�!��Q>S�1iE^���ezcA�X������Nb%���U*rfGyc�2{���D/��CJ	ϓ�R��H�C+�lY��\�g|<L�[���q@z�H��x5|׎�;���ux�q��� ��p�����x C���eqw����h������}G�uU�ٮlT��X�P���Ջh�S��
��i�,��^,�:�j����
nC�߃�,��94���Wm��ĕ�����>=�e�=�<�&��X��7�f��C��񓖥�)>-�<r�-彯3�\ڨ����T#ڍE�Qr�ٯ�ӱT|��ӱ}ƭw�3A���:������Gr )��<g�+K�R٬rw�-LF9����򐹖��)g�L�BX>bM��|p��	|s �{Pc�v��a	��f!�M��%Q����Pet����ԟw����3k�M6/wo`�U*�ଶ&(���Q�NU8Z�B��w����_��cm! ��7���T�76d`����$x��ܑ1�9#ƶ�s�?�{r�]LP�j�C�]�Z�ɍ|���/I�h���&(���Օ�S�hH���Ҥ�V�jy�6,r%�[�|4ӊd[��Q�ayܰw�k\����&��ND��?������~���ҵ<=�R\{m�X�+��;�^�a��l%�r6����&]׮�c5=���$�N?�L�Y���w����|-�t��Ju���vC�~T��Í�P^^�'�2�b���C�ۏb>OR��$p�+�Ϸ�U:~>w�:�K�"�%��Z82�M�����-�
&9^o�˔�ثlN������[:\b�+$�C��G?�a���S����mQ��P��$QF}������+�ԧ���H0��&���d��ಒ����EJ]W�� ��V�ُ4^1\������ґ\F���rˏ7�Y�g�8��")n�+�s�H��"�=��*Zв[�p� ���qq픢�o$����<_��U,[�j�v��8�.8А��]\&f���Lx��L�}k����;�KK �;�K��s]W�#�=�r�ev�{�ܝEQ�c��C�쐳����Sb�Y* ~��y�4�X�!� t�aW���    ��w���I���\�g�><�g��YUc����	G�o�Zi�gM\>W���-h�U��$y9��H�$��QlL��"���"`�W���Ns6����K�X�(V�ȵ|QwDN�P�K�ҏ�j�7�����#��6�1��]f�7�JI7M�Z�7ĮP+9��Xӗ�sPN�w�rZ&�&XmI>�I�Y�%�,�Ҋ���j(�QR˭]W�-!5������˱��o%S��
��О�cc�(29z�M��S���y@j�O)��e���*Z��M���g}�%�ڏ4 ��A���Gj�ð��]����U	������jf�9��8�����f��[��$!�e��Iv�V+j�����f�um��9��U��KLTi)�F�`����/�����ÆI-N��'�>��@u�6�j�
u�H���T�=xn
��s6K]WO�X��-��:�qPF��3�K��{��d���,?�x�/��&o��N��D5�K#�)�U��Ŝ��v�jx��8��d3U^��O���a�4�,���=��kK�Q�o���܏�i�#�5!V�Ū��z��%�i���P�z�����ty����b���S�"�"��x.�0R}}P�=���@C�	W�[Hl��� 1h|�><Kʓ�^�i�iw���p�c!ߴ]3��RK�'�� ��z�K��TÒ��J�����[��ϙ���c�҄����!��u�|���[�fD�͟��������s�������oO�@��yXR9ꬸ��\W
�7�ڽ߾� ��} ���2�^��S�����m��^e�1��ǬB�A:OT脉BgƝ˳	��+s��$]yX�P�rj�afHbO�6l���d��l�џ
aw�D{�0�n0<u����ٷ5��q��i8oZ�FtF��Y��+�.��⥞��X�C\v�Q�l�u-�K����q�@[�zrJ���)3(�w�tN��u��"��X\�:V)É��l��\�s��:]���(��Qi�)�}��u3��rɠ�F��J������y�ό�
>s�,��ݱ�C������~�P��ԝz�î�:@8,������f#�!b��R�d���QAg}~�f-IT��%��y��zb���eKy����w#�u�PRE�.+�jݏ�De��h3T���zu�f�7<t�f ����Z�+��]}$O�Y��;(��%�4�s�ϰ���O}��ʼ��f:�K, O�Pp�<���G g�����~K͹�ľ����/�a! �� g���z{�P3�X�g�lgz��Z�\��.l��-�ծR)��� -�|"�[b��1[�Y�>u��W6Z�c��_&��Bl��G����̰�>�Y��=�F� t��c �sɦ�"P����`�u�Z6f��Rq#���?$&���W�k���}	3kd�3Ba#�\}�l�Ѹlm�����~9E�VT�>T$g��.�a�ǒ��>*!������6&/� ��	l~�'� ����'9�����t]�S?�e�RHů���M�Ա��Z�6Z�aCT>�i�G��y�ʈ�G��^I����aq��e\�T$��|d�T��2e%}�����U۞�\�7F|J��]�$�����6Z��k�c�J��D'���pM�6��tj���e�TR{g���Ir%����3�m�����a����W(��Tɐ��:��(��
6Z_G�"R�FY%�H��7	�y��۵*�8 ~r�1\?���}���ډ��\t���~��`3�+z=տ�V\���KN)�Y���<�$rCj�qť-^�㉵YD�q���F�
� ���c����n��4+�v^$�:�?�P�_���Ɵ��SK3PF6����mqw���bX�	�� 7�0I�۔� Ȑ�C7K����S��	���W ͆��l�5�ASX����c���'���GE!L������ګT��y�̖SD��}!��Fη<3�ɕ��'k�I�x��Z�l�\I�|�v���v����,��ֺQ��f_�?�F	5��`"��<r�Ӈj�k��x�{n�c��$p�}(PS����VY]���u_z�{�5D�<h��Cu�8ËA{�uo�M�����e]�撰CT�Q5`��k��a#���l�)���ѝ���m��j%�Q.�7`�UƲ)_��'�e��8&!���F���:�GY7���ys=�8�&14 �U/P�`��	��f��]�"���sA�IE���E�V:��C���6qդ�`�(q��G��?6R��;C�.���6�9�QT"�K��"�B�,���wڕ	6���̛N&&r��L�;�z��|���)X6�W��G�=��`�\���
 Y6����g�쪪�j����Ё�5?3�Z�i�N�� �RW���P��j�{�%P:ϵ�6�"K&���'♝��z�[�U�r��X��s�/n��{�X47��>�.����f�6[d�Y7�[gys�I2]V�"�n=����Kl���C}�P�:$�`��v)������TN�nz�����H{(��V��,"ԓ�1
�o*���6�k����3�c�d�z��j(���F��t6�[������x�
@�b*oU^�9>ނ���2��.��Nx��T�ߜ��˸� @T4q�)<��_%?dR 5��6��÷?�G�:Dޣ��ƌ,X6w� �R�{
�b@���h*�'�,��+�ٞ�2F`���o�(��a���Y���SE����%��C�??�5`�]a�j~'�w�.���ж��%�ҥ�M�mt�ܻM��	DCU��	��	�󠬋��F�w/��0�,���p=T���Y?w}���]����&|K1DLE��`��z%�pӝ���Z�\��-5},"�W�2�)�HW@�򳍪ИuwRPM�>���$CQ�yЇ3�2���T'�=mXE@�ж6\�qjA#��G�i�Udm]w��5��W:$��s��؆P���@I]��٩���<�Ur﬙����V���P��f�?X9�U���F�Vx���t�v�_�8f�7�V�]G�M�uz�֐�я�ƥi���1��v�DG.�(�8�%q��V�R�����M���+K�����!�ܦr1�2���;�ܸ�#9�,U�
(Z�w��S9� #�^�W�;�ꛥ*��TR4��sI�tw�+���n`���v�^�ju�ZX�9%���P�BaȺӾ��n��a��vqdYO��n�b����'��Q��ٽ|Sm�x�)��B�����!4ݾ���fc�������ZUSt�6{��0�PB)n�TrXk\vL�d'U��ٿo�I��R`�ћ7��Q� �ec�jw�����0\�>7�TI��t�C�pp�U�P>&��Ӡ�E7 ����[�q6⍫�Fr���<���R|���쳪�:7ߨcz��x��_�@>��U#�܅�8rU�.'4H����U�LR�X˻��B�Iۆ���������.�0���k�ժ����C73����S�$�JcK��1�̢ê��\.��[MY�j��rzG�V�m�= Lc�݃7A5�c��X$����/e y@�j��w���ၠ[b~�\���%(������ưz�W}
ԥi	 r�5�\�C��
u:Yf��t��_���v�~�(9��^}_�Ω�V�6%t��Y0U��T}E[TzM��׸�qcF�ZheI�����8�?m;�9���,��<���]�:{�\����!ݨw\�@m$���h�B��5�O#�G�K� i���꺝�4�C+����d8h7gF�	}ץ��$�Z�|�u�˾�g��UI�h2r��6��+���y��u�h_���~
��MA�g��zZ���r�/VY^NE�ըcf�AF�lh��[٪�&���i����R��W��V�1�a�t �:�s6܆�v3\?\3:`�˧�C�g.J�y{I��6Z,A��!�ݲ�;��n�*4�r�~�.��#e�klc �<�SP�j��HkF�������_���u�,�a�����I#�Lce�u
��B}vv�uަ�ND�>��H6>�}O�c�o���xL�Z�m�h��    8�>�t��j�2O�]U��W9{#���vy����C��S����c�qS�]��[Icd�����I��z<�8���� gp��y[܋'�V~�I���H��_g��T��isl��Mb�&1�ǊF�"�"_���. q��D��	���m�[���)�,�kb,�>�uzq�Z���5��|�q

r��=rk��j��/���)3[uz �h(u~U�,6�q�#�3�m����~��)��Q�'r~�����F�����ϲ+i��9Z�R����4ǩ4����hӞa0�U�<���.zy�qI^������ɳ���̧�����;~��J���iZ9��A��/XT;v�R	(��ϊ��/�D��t���vq�z~�h�{B����q�:�.�sI���T�R���w\�m7I�<+�.��1�S�O�K�9\��f��G[#���Ew��A��?U���\2r�����⼟���@C����H�6�3F��������e%��(UlLT�/B����}'�&��yA�<&���0�8�_=ߕ��C�V���H'����Ck�v�E{ٟ���'���T�*/w���h{�g_��A�c�<���	AW�a=;�O˄�ӽ�rhw���H�h�wr����#�w�
���F[�F���Ղ���E�*s3�;7[V�UևgN���F��}���R!�+�������4Z@G������Փ�D`�:�ީ�`M��G���_
�������Bd̍"�e��]��9f�����5Rc��H�Ce�:?:̔�ӭ��m0�n���7��Oa~J�+��xJ�2��_]WSJ��	wޢh���ʶ$����'r�^$ai�s�lg�4���7��'d�#W�\R�]]�V�o���֊��pܵ���3i�%�ߧ��c���Yw��l'�3�F�xG}�$��}�W�o�]t+F��^��澼�r���%��*��f�]��84ޤ�M=�=��KY�j�N��c�K���,f<r��8X��I�U��ĲK_'�'#��K>�PR�e�Fz��|E�HJ^�	w�+5S<�Y0�	�C��E�Je(���	v���o�LrH�z�H��_����_�gټ�<���v7�v�OM�&4�P�T�]j~v@(��:��Yv��,���b�#��[ÿ/�B�ԌBv�k�+'׏;B~p��P��u8�WvT��ec��j�
�����J��}�����
����3t��7����f��a&��Rq|�Ԋ�W�K�Xw�G)�t��#�{QƐm�K�l��7�qFf�UH��d/:�J. ��/�8�׈�1�o_�P�)7�x�]H���G�w��ҕ��A����SE��n7�$4�Œ s�D��Z�	�RJэJ�k�����n�o��ds9�y�f_�����m�kn�+�-����&g���Ͱ!�4�j�P�-�u��%A��ֲi�r|}P����v����=��X~=8����F7JiyW,���hdl�x�q�����V'.��������x�F�Vȱ$�9~�*�v��z�Ѯ��J=�ND_��dr��sYG6���6�w��ɘ x����u�w��
@��ˈ�v=��p��c-�E��^�� (�P�*W���Y��xw|�}�iɁ�=ذ�@c)c|���hw�(��mFI�i}��Q�|����}�ڸS�����c	�N'�Ru<�:_J:������@��D���pTj	��E�-F�_�+�^U�vk�.��Hj�3=F�����N�X�8�9���_s�|�-B�?����TG m�����r���ܿa����ѣ(Ty�o)� ��Z�� �Ԫ��i�Ep��Ձ�U/��^��ޢj��o�|���`�j��Q�??�Z~'Gw���.��yk���t[�1�Lc>��{_�g����s�ư�:Z#��\�ܾ�<��u��+,g�[Л7Q��4l4�](�)�R����E
t9�`��RG�����R9�b��Kt���`���`:!��o����n����������ص�������Z{V��!��N����b���`R� $^������&�%�����8j�ʁ@|�J�S�"�,�s�l'�:[l�S6��}�:�F�M����q�{yb�@����3y����>�%��y${s���u��d�c3I��;�Jƚ�z����\�t9A���Žzd�(hb��� %/�9S;���Qѵ.o1z���_��96
e��~HTr>��^M��l_�_W�?��? I�'�9�/��/Jr��R�w����k�>��U���^e�F��>���C�����xK>m�I~�r'��zL$��򀎧�vȼ���|����_�Zo�Q��E�S��u)�~0d��.Q�m�4ԻE�����T=���=�&�3�-C��Xڨ������z���/ځ�R%+�͝�;"O�}uB!rU*�3oA�+��}<�����ڊ�1;H�@Nc9NY�X�!�$ 6���PM�I|F��K�
��H�}���A�R��=�b��"��ǹå��Y��{�}�����',EW�D>n#.�ߖbU~��C|�MP����x&���*�3� C�}ǄK�H*!�p�*�X�,��XN�7�T�n�{ζ��j�ՇWNsx�������^f�����Ρֵ�s0�m� r&����E�z��Ո�3?:����rј� �ŁC��b�K��SRY��8JLX��qUO^]ڀl�j�U�.��6����ͩ��G?;�$�?� o;c����W�p�w�DRIy�cZ��F^Ewv���ϋ�҃^�o��j0������ ��My��r<�a3�a�i݂�V�1ߵ�	)���W�tm���Ė\1��JM
|u\��p0�2Y~��X�� �-!�D�\n����� �|m��""�8�1u�Na��lVK�\�5��M�w����R���1�qCW�
Қ�]r0:('�Fӓ���AD�	� ��8���dk ���q���7M�������t�=��(O9�5��l((�&~ ����!�!Ϥ����l2X��I�7<�q��j�(���.��a�kФ�T��&��+GS�.��%��հ斅�M6��j����5#u��?��y���gʡ�R�f� �ש�8_yhf1��Ө�}vBWQ޽U��M�O�/#k��������@:+��MY�(�l��xX_��#W�c����N���j�J;s��囦|���� ܥ,K��z���'�uj�f%����7�ES�AN�<	�-�����H��_�>\�f����57j�PҠL͝����,��RZ�4���*��`IC��ƪ_�6+y�H������o����Z��m�>F����3*ud�f��G�oy!��+c���ku�'�bsF�?���=|�8"0��k�s����fi� v�1l�	�lL�����Rm�!lJ�?�d�ՠN,�6��<lo',�O�b�x�LK��q�v
9c�M���a����I� �������֕�{���� �Ve)D�DS�����G٣r�éA���nl`��+����n���&��rl�ñ?�_ڵ��Do�>�S��{������W�~V�a�k?�$/C0�Kq����4ʃ1�Y;9*��6�"/��8Q�1��%���c����6��CAC����4�,XC�c�5���~�\l�����	���hj�G�q����@_PMN��N`mN�wO3(Åc���H�J~f�m��|��K�ު�nc���Z�~����ne����t�9i����6�胩�|ο��qN[]��-�;��t��j>y���J������7&h�%���kl�+8֓�W�6��o�J/N3���;[�d�M@���9#鮥��w�a/_[W*�AUe�<�E/�����}���N�<�ia�ԧ�^˭���8Ƭ�u� ��kF��h������\3[4U���(A5�l)�S��v\�6a,�]���d�g2z���v�WM�����J�b��Q/11�\h�Ay�2FC����ͱ�X%S٫J�M=9������ppVK�6��w��VY�>#�37H-E�#[��Ԭ�Dy�y���s�Y�D
B	\�ai�{	�'K`F    ����_t�}�v]�4l�f��?��b�h��F�36*��`���s�mG��	��m�I}C��$�o.���l���Fm��Q����%���V����9`Wʟw��5n���׍�t��B���>_�$k�C�k[ދhӎ딧	3&n���?y�N�tD�gQ>c�	c���xb5�Vn��ᐡ�q��P�9�W�kܮ_s��.��>恒�|���}��%l����f�a���Zɩ�8%���O������|M�ިɅv����0c�4��'����U�8���V�\w:�:>��L��i��@���q�Y9Ն��-�lw�'�k����
���ޡk���:Kń�m}�%�[yIu��SD>+�QW�;��^��m~���e��Z^G�$^��,&��������d]�V;�1�g
�H��\>̥�������g�݃��b'���<� 
�%;3ED�W�v��X��Ter��7��ߑ������^���5I�x$i��h�J�o���ok�"�Q��)'$���{�b�}���������m�r�wk;�����_�9>��T;�]-E��]l��3亶9@�8�f������u�◾���,�2A{\�@M0ւ��� 0����йx��Ϫ�5,mԞn?*c"�E2W��<��
|\+l��>�gehI<&�R��(4j���~���N�i_�����d:�OQ�HO�x�*Z���T��(n�O�h%S��ʹ ���r�x�ފ��#+l��6j�Q�;�:��l������+Nn�f�k7_ptd<�\�{�2d��C�&m�-3�$1v���s�&ű�����y3�����ܬ��C�u�kzEjg��:)��s�)L�/���p6A��O���,?LN2u
Q3v �ɺ�kfl�Z�(kt��YM0.ZE���܀���R�.\�����K
�Y�<�h�:��R"�"���s����h��O>q;�'���ߍ��e�u�"[v�jnU��:�5YhG�P�I~}Ŀ}`���Xܴs�G#�e�8s1����u�ҥ��|Pu?y���J�@Qa	���b
���D;��.[�Y��F	� �4�&[ʃ}�g$G�Za��F��o�bFl�-BrW1�
~[�P� �.7'q?�\�D�.ln`uoz���s��B�d+tŃ��g�<D�Ё|�N��2&�՛kܕ�R��F���y�]D�/�F��vX^�nu���Z�<u�C�&�8�%�@�/�W}��	����A8�^�@�f�J}ccl�>��ua�@�$ķ��X�K�})n~�{��{T���1QW�($�؁X]�M��{T\ٟ�
S��m�C�l�5�+�w��b����[4��i��v�®bH(�74y����	�I�&��G ���C~�#q���M/I�g9K���F]����Te��mS(70�r�΍h���T�u��	pil���Cߕ�� ����Q�i�-��v�k�BfU�4�����_��=�v��x�+Q�JI��T�8)b~���:�,�Ӵ>
ߩB��D�`���5�{9	N�ӜL���u��T�^P��k%/B_-�,��sv������&��y��A8*9�!�R�	�eX���ۼ�*��;�5��;���Iվ5��%W�b�-�t�r��+���MȾ������|��ÎE��_�iƸ;-�9�C2�O�}��d��6w&��w6U#A1NH-i4�oGC�vV[�Bu?EsS;������FL<2^���]K&-_�M����k5�
��L�,�����)k��=�x ǶU���������_<��}m���U���J.����8wR'0:��.�y�����޽/�V-*tS��#5��~�g3�C[I���޻�w�G	4S\�}t�(>�0B�-۱�}�{�#{��d{��Gxk���TJ�#���>�ͣ��>v�ē����ڈ �#Wc�<-M�ٟ@Y'�1M��]y���)����V��H)��>Z��~�#׬H�<�d���3Z�-=GJQ�c,.�d�S72�]�)�G5��k�^K����'<��	��In^>kk��Y9�7N�K���o�k�S+�w��1��!=�y>?��Ξ
��
���<�3<�y2��u�0��=C�������$0&�ƅ��G��+̲�]�������VW6� y��.����6�x�eh�4���b!��eb��'sWىn�|5�����R��6��\��-�v�5�a�ݏJ�=�c���{��j�N7�DJ�&�t���=Tt4�+'^U�_��̷)��v�.�j���s\�)�y������T'���>�\�e���������td'�4�͠C5@T�ٟ�%dN�b�o'��Q=Pi�8-�i��G�����;�r\w�ݕ�uh	T/X�g�l��I�X}��lA��ơ;��v���E����TȚf{$=s��-ַm�sW�ٻ��>IN8���� \�����x���0�S�Ss���x+�S&�w�s`��Ǝ�.=��u~9��z��u��
/�w0���'5���f��M�C��	�O�����#��T��Ա�fryt�z�e�/��q7�Zfh#
��ڤuߛ���fƲ�˄V�7&�`r���R��5��h4���*����r* ���b�v�M���R������t�ɉ��l�:��c0o���#��RϜ��z��[��g������<�tH�I��d�6ڟ�*=�v"�>�k��X��a�9Mǲ����f�R��-��/Y|�q���Jmn��ejN5�A*m���|r~�6m&YQ;{îhKg��`����7�t�V�
v����G�篲*�~��gK�|2�����`>� tt�*(`��?�mux��>���K`�ߴ�&J���.�-��˓�
ŷ-�g����rǿ^R��h�ζ���_�dڃ���1��}9fS9�"�Lw�(����m�Ԭ��S0�6x3���/`��G���`�Ƿ�5~
�l8ȟ��`��Qp7	ṱ���?r��:� m=Ewb�QOw��8��?���uu+���n��O�<��>�W�b+�0Y�x#�G�*y�B��\�Bק�F�س�F]@b��^h��ZjϪ�)���wc���$���QB{��	}Xo.w\��|���	�~c������7�<3�sކ��W����,�,������l�g�h�"H���A�g6p�m��S��s��U���rq�V��Ͼ�_*�K;��TL���B_j?к[�dG����ۋ���Rק�N9��� �T�/pS�Z�t����>�^�7�*��&�x]}�wU��ٷ�t��}=��i���(��P0b��*E��$0p�ޜ�L*g�L�-%�A�5>D\��Kڧ���Wy�6N߳<UѦ��Έ��ڐQ��A�\6�a��<����}�QG�YU�dnD=;)bTE�Y;�6z��@�c��	˯��F��K�\��d}�{�:���z�F)'�c�B����S��X1�:��M��܍�][��)�y���ꚕ�_�˰�Je�5��o�ڛ?�{�6���$흪��F�C!;琍�S�`�r�����+<uù#gBu�+ �u��^,m��_`�%Ex{3��J���z4�~�.8.��ó�Y�<=��RnL%7�C�I[�K��;�M�>�&x�����'��J�˵��g�y�o��88���iu>o����S�+�H��o3#'],M�t��|{c��}%����VO�nﴅ�O�m�k�+w�,�T*#{�Y�*�0�Dm㧓-ɲ�t<��<i���j��R��X����<K;qh0WQ� �q� O���̏��<M֧��9��Ϣ5�#�c"�iy�Uh]֧ˣ�kh}�mJ�AS���ۯy���&xz~�"G�+ %]������+.�T�ť��n�k���p��	�xޣ-����:]{wQ�~LŢ��d�z�\����o�8$E���b�C��Fi0Қ�.g���<�3��\��j!u��D�����;>���ͱ����˲m�3�Җ��Q�
ca�#�]
���N���]�^�h��ک����A���
ߘu����߲���G9͜a`�Uǖ�`?5C7�̌U�.4��FK���3�    `�>~�X ��aSK9D��6h��M����i2]��֟�ʷ�� od���]JR�ܚ�O�j|K7N]<�𒀟Q�t�9��,kg/��l�ŝ��oo#���'m#�u�J���\�~r^٨_��/�������~��*��2��K78���C�O�L�&A�#t���a�,]�pA���2A_��|���'A^Q�#S�j�<�>��zO��\�&�s�$������?�D��K��Y��v�8ϦƖ
T��+��v-�I�V�n���}�o������cRj�bH�~�:"��kd���c�3W%�����*1��Y��U������["��cV�VE|%���@PӣK���b�xR��,�� �#�7cgw�Q���Z��J��1O��|���Ǻ�;������X��bF�t�� P鑢�f_3�͛��o
h�/�ɨ:L�RŐΨ��!�)i(k�ީMp_(��6�r~-/kr�_TRg�k��:�w�W�mp�I�'��$���m�k�_H~��ǰ���!�4�]!7�~��rTrn�ѵz��	lC�ѻ����-�W��<�=R֬}�@��Q�� �F�ޭ_��t���b~��RP��NX�+��e̜ɠ�ju��{�}]�<(�CL(ΖKղ�4�d�(ɔm4A�v�ꕇ��# 9��.+D�4���'��t� �@�����@�]��_��F|-��|WU6�
uE���@R>;�`���1�'x*(-t�ԫ����9?�k�늌W[�Y��\̪'���PgDBB�]�[:ϫ���&��4M};� �|��-�t}Xw
_�6�8Y0������P���?� .3����(���	�W��|0�-�v�y�|�v%"�+Y� >�x��КCSJ����ۋnI��u9y�c��D1�Zd.�_���!;U�A^j;,{�+NW_��!�
,�*��Z r��#WC%���?�-d-95d�2���I(T�$��䷓w�ꞥ���l�D'Py�n(��X�����=K��=��[J�u�kX�9�U����膣�k�h�h���-�-e<��S���:/��'@~���)v6�LE�"�����A�"��=ֵ�ڪ
��l���udI����tC��C]m��*�Tʏh�J7mnհy� ����Ց��QN;�o��	v�o���M"��#�:�;�����rg;�J���loFr�g�w�ȁ<xQll%)�Z�f��@1���\��+�EN��dY��8���]ݺ;Nyϸ�z*�����vQ���%��l�E���m�n�O�Bz)>04=�����2������G;:��'E N�éп/dwj��L֧�!k$�ڄ�����g��Q��O�Rr���绗o�fjHd�ʖI"���'��t��o�����Q����R!A5��H�\���xV��Id���7���L�[���ے��+����}&�S)��F���- �?�gr$�AT%����x{9E�ӳ-O�M���W�1�`L��Wʖ�!")��η�Wc^�*Hx��z�A��%���?�R�M7}
��YU��æ��U��e����]4� �c[<��G$�d�|��j5�]&x��z?e��h�?�}$���2�}�#~�:���� ��y�0s��DZ=O�_:
��a���f����C����C�րB�v�D����W\m��?�[��z7��N�CPxh��H�}�qa��������'�ON�]��`d���`>�y)u�^otu�~Cd���0Ȟ|_$N�)F��Ɖ��_�E���;�����&�U���}�w�{��FW��k-A!Ds���\�J��Z��	�����Z��7zIz����m����8;��x���Fm9�NO������)XIKj��H���7�*�&k�8(����Ͼ��߸�M�f�>��H���U�L��::�;>)4p��Z����C��K�ߪ�TI* ؕ>��n�PT�d���kE��z�����U���{��p#l� >zy-P^�/q?��aMV�Z\�`A�ny{rx�EOs�H.ӎNg�=����>��Z(r䦲�~�C�A<�̺��_�%�s�BWw��`�� {��	�$v��O�&�N��|�nn98��8F<Q�d(o���?��U̝�.��G@�>l1��ts�UEo[�����;�Y�R��a�0`�-]�s��P���QZ����-Y�̦*T�i,H>�N�'���wa��r�Y�c�])��N.^IW�vĹ ��H�'��wbܵ�H�<�_�L�ج�ߏ�} O�A��7h�� _�v�l�{]&���z����~^Ͼw\j�9�����Zź�J�-�A�w��b��}���*Y���ս��$t�2�/�ś�)���v�Б���t+;��W\�!7�!&�?��p㰺����Ҍ�	x�8�e���=,�zNAJuVwXT^����������Y�$���Y�,�a��] �ݐ�o�!�@Ӥ�W3[="�g��=��Fv���J>B�u��I��u�k�'����}��F��O�e޶y�ŗ�����/��#t�w]��(	��$���Ɇ�Oc��1an+,�0HtQl�b��R;�|��{yT�ҴB�����G������n]w�������҈�PQ�$9�vfk�Y^9��z��F�8�P�%f[a�"V�c�%���w��k๯Y�'�ΑNU���<# pg�$��M�y7���^0x�
�&���k� ��j?�����K����SZb{w�꟣��S��W�2g�./?�Ċ��;��kϾ�[�<���F^�GX��8�𯩊�rC�wA���������c�����mB/����DC14��f�8P�>�Z�@�ŷ��� �SJ'qȏ�ߺ�f��?t��	�d��v� �%�w��r��^|�G�D* �l䥋��&��_*(� ٣�:���[.�iY<$Ca{Nc�����1ҫ����]������{trI�[n�%�B�bfJ��3����^�ؗ���_F�8[� *!�Y�j\�g��/)d���f��Lh��3��S92C����x)ͥ(��voo��m��W�$��T�؂ �+�~�4������k1��n�υV�؀h^��[�M�&�g�z�̣�J\������0�q��ۼ��!�O�A��r���8�Lv�ã��WݣMk���� ��0adX�ϗڬ�7Ko�(O�-�j*�~��&G�Ј�Z���8<����~��Ew��1�	C��K9�Uh�yF�G��ȶwHb�$i�;�Ky�;� �;�BW��������W�~ V�l :��(��5�`.吜��
� �`ޅ
����0<����`����9��g��E�D���Nɴ_*�Ƴ�T����z0s���ա��ᷮ_���}\u�76�hUP��5%|���f�F�4w�J����U3q\��c���~��*A38����4M��<-ꠔhxZv���R/���׺z�W,�L�����yD��<�}9��X&��7�A�}���燒�;��#�%߻�^*���i1t��Oq����\��P�������e�;��]�`�:9�����b���F��}S-��̎? |���c�F�-C�4D1<lC��K����z�#l}�X���`��ږO-U5� v�k����ΥsX��{�ta�>�>�C<'>v�1�o��zg����_�cFS�C��f�:W��\�ńc���w_%�ģ_�J�)�:EN�"���[$)�~K�{�v�.��j7G�+�.�6Q.���σ	|�u�c���i�{�������}�^�������p1�	��U��V氼8۝�~�P���*)xD�A����w�e����u$�ŏ�*�mi��A&�5�6�=~Q�]����- nn{��v�]#����`WH1�
���$dl!�1yWa$�X���[������F~�XAK�)�y�"5N
�ǩ�3��P��U��g��B#?�B�������Ɗ�r��������X�4E�Ԥ��X �s��~~��:�]vo�o<�1 �׌JG΃�_�8����M�p\�Z�j��ض��ls]��A9�d5s���H���Sy썹t��@����[�+1!�    [�@����D-[�������zaD��n+�d�>UFΘ�����F���̹�0�k1����h�ӹ\K]�mX|��Ӌ:�ZJ)�]Z
G��U��l�������~Z0��Q�iZZi��u5`�c"����W��jJ	��CF�Y�Sߐ���f��ӨO)!��GdS��}u�q�P��o�ٟ@�5�#2�3�7�?8 sǽ�.�%�.~��sG���U6�"˶a��*p�Z.�x<�i�w���]�
�2$Ǵ&�L�󪦐������_���Y�+;�1ۯG� ��=��?����Q��0��'���5���e���w�����\�Q5[9�Ѳq%yW����r����o�0��A聋t��a]���²�������`2����~3��q���F��5��0t�XS�/J��38��\�e�J]�ӕ5��pV�����1�U�R�K%��L���.N���r�3���V�2�-J=����q�F%����Y��گ�s�BI�@�X>�a��Tl�A�Zn�s�=K��R��lL�?ߊ��֑D%��bc��^N�IMA]��o^qj�d9㋃]�#�&;���:�5p���9,}XJ<�R�B��_�;�hH�{޽Cb�H��!�C t�ȱP!=�"���F��?fM�P��<uAYʿ��R���  ��� ���jj7Ww�/,F��6R�ɧP�[���nc� \�e�N�Ӊa�Q#��x·���ȧ��S#�'�|�8�^�"�����1�8W5�������s��(��%��s����!�x#k�.w�2���	�d�π<X��,��tT�R��c�=���ϲn�����;c�zڿ|��Z���iE¢J�-���־���/� �������&A���3�R){��P��a�`9�W���F�+_�������A�U� _�%�)�[��p��g`�l��)ȘW9RGh�T`�o]i�r�{Ѕ�6��*��E����c����G����,O��D6w�L'
kX�&V�lP�ac!�_K��<RI����o�n]wGg[M�֋cu�':4��D*	K��ӭ��^r�%�HrQ��s�dV2jH��a���Bb��ݘ �n��5��� g3��lW}�Q{�J�����0����&9b�rc�vJ sd��4{K���K�@2�����4�	*�r�=z>�>(*�-hѢT2ߚ ���m ��ֻ.zkǵ\��V�	��V%�n�|z�Ss��Ј������-u�G�e%[GhSӲ��LegoNr5_�,�5��퐮mY�'Κ�S'����=Z#|���8�����^�����
���r������_�3��Y�� x��l�;�7��B��� ���W�Y�*����7�n��0���c�Yrv���M@��
�3U��Kuw����3u��ir����ܔW�"�9*R�5ʺF���nu�b��x�6}���&5x�����C�<�,�i!�R9�����yɎ�����e������DMmq0R�RI5>U��:�/%��pW� �1���aX1� ^��R @m��M\�K���z0F�c�yw��~�~�;�E� ?�a�<> 0�T�jk-���f��X�_� d~�bv�lrU�ǋ�P]���)�����/�;�Ą���-*�q�Z;n�"�_��%��$ڏH)#W����y:�KXş���N]� ��J��U0�{u��S�VUH�� �5�s�kC��?
���ب������z����)� fo@J#̣�$��z��G�,�&o�B�_��E�F�R�%���R�E�i�Rꔭ	�����Ђ#�#�w?ˁ��GzG�����z��[��*κ�^Ö�OI�+�s����7�8T��S�_&x����(^����#&�g�3�����_o�ܸ��o��O��]u1;�l��v�]���w 	�bQ��=��};:�GV�"��g��av��l�Sh2��?*�5�^`�N9�a��65*����'R�i��Ee>Z��m��u�e�z�[=^ $�2Wo<cN���J��Xt�n<S.�ʘ���(g���|��8 ���5,�o��B��Rل(
��u���%d�͒%\�Mި`�ZD3���:1�?1�S��5Q��R�I�B��'*r��i�֘���٤ե�.mnn藩�8y`D9Ri��Z��+��)8��KX��Y���?o�\r� ���7��^��jn��>Nv�A_�m�/4�y�8+���n�Mvr֧K�n��d��\��icy K��n���4�,��Z�}��)����F�S�k�h���gy�^Ot�%f�zrD�y#"')�A����>L�7�� {��	�V�A�>6Le�6ӊ�i�0���TS]Y!+ϕd�?c�QO� �4��7�~!�i��'�Z4P�Em���8����;��Y§k�@ô�����H*4H�*��rT����C3×\O�P~��1���m�r�y����*�Z��*yH�SnO\3u,3��Ǎax�����
E��f����V��.���9I��ɴ8�
]�����X�H'��¸Gn(���Vh��vY.Y��� a[�I)�V�@s��h��z�l����k~l��c��@�vF���m�ߓ�?�l�Xd{��M`����0s,t�}�T}�I�{]��d0&�@r;ຜx���`�.��E�:|��ͺd��
�*���Զ�-�ޔ;純����m���
���h����B| ө���F��$m�AA��1�4�U�S�K9��9T�p$7`����x�
QT:)����V�X��S,m��q�aо`M���Z�{��
h���VUYFY�(Xz͔�Qn`5L��c����� 8�j;�6��[�il�t?Tr�d��������d��Q4�<$�K��L�}r�[�4H��x�:ִQ/� �?� ��.@�K�B��8�>�VǙa����Z�*���a�-6�T�+r�_���&Y�T��*�<.��I"�]�S�k�R���a�lW�5���b����r�U%v>4�fM����&�n�[&��$}��6J���:���.��	�\��~d�.��D�ڷs2{W>.���R{ux������qT\Q�_�*���8���|���M.o��V+��Bk
-q���D���>�v�	��l��qrwyd�s�@�_U�Sy)[� Z?�O��3����d�(��K�|v��|�6�Z���cIȡtQ@�rl���6A���e:���,W�yX� �|U�dg��5�^��RdD������/� ��X�b;ua�h7���L.��t��Ayn���Y[�-��mՏ�5��4[V2L��E��_jp,w���a�,^��}mW��c���ߓ��|^J??�Fݙ jo�HFlRyV#�c�TxF�M����e���0�nz6��9�{�.wQ��7o(��/R5;���hq�yM�iO�=3����~��8 pv;D����9������e�����A��'�'�E�m	o�%�b'<���:�<q;)�v�h5���@MsQX�Q'�_�Za&��Ô��X�#����tb%��i� :.V��&|�'[ w�s)u��T��ׁ���V�ggzh+ҋ��;|�?yn���n�b9L�46���`3����&�~L-�"k�(j�zć�R�o@�H�����ѝӜoq������9l���_�F/7Zf�-�b��qh,m�)�_��FvC��þ*�em����܀qň1@Q��A�(ɷ�|�Q�.6G�;CU�$��Ei�:�)U
�,[��5�n����	�7H���F������{���s-Y��b���Շ� ڋ��;������Ԟ�	�������:��&YW���`:�g�8|�s�7`���?��E|*Ր��5���=4�k�"⍔�{��P��8��ac�8��d	lʢ������ò���cV�d
��W��U�g|�`z�ב�u��������qz���[�����3+e*0�Ǿ4��sg���KQ�����'E������_���Aӈ�gR����0Q���*E��mѹ�g)߸䳝	�˧-�;NN��OT@t<    ��B/��<�Ð�{5������f�}�$��,�k��;�F�K]��#���նy*��Wy̿�
�>�ξ�x� �jt@ـ(�]U�����	#���F�x�g؀F��2�Z1�Q����6+�3�K]��b�ٿ�}*QR7=B�e��"�:4ޚ ��Ru�~� R��)������<�<4;� �>Χ��)23�0��pюzDٷ�ƻ[�v�]~�Z���i�������q}M��E�9�䚆�P�;���ŗ����yDZ�F�X�&>�z����[h!��q01a�.
py4�\�NQ݁��x�%�z��tA{B��{5����
A$�S���(޼�"��4(9���O[{�>>�
кv��$�<U�s����'��[z�[��h{茀q�^��/j�x�5����ʺO�N�)/U�8�`N��N������Y��Q���+.j���03�x�e��X��5�ͷ�&�+!A���0��\��n�k|�F\^<�D'<���r�4M��c� ~�5�,:���2��1N���~�ԇ�u����bs\^	@���Z� ��/m���L*ڳ)ʫ��7�E��WW�o��S�XhϼE��KyڑqK��A|^�J���&��Q 0�J��|�Tf!ۗ�g?�\f����8ݷ�U��Q�k3�>����3��Ϻ&�Ǵ �J��%3�9G�uu�Q�-�c��`��}����81e�s�}�/�w��I&޽�X�x�,I{���� �T���\�a"I������"�ׂ}5TF�~*2O��I0=���E���8�_��̆�Ϙ��`�Y�p��OǊC����/J��}<�G�zȸ����\6Ke��L�D7�y�{D�bf�C�w���sy����#ݸ�\0�B��c�h��7Ar�"Ҍ{�P���m7NH� }8jCi]ꚤӉ^`�$���qx���N����uE�A�M�P=T��f} ?l���P�Z�dy=���,m��V�G�kXo��;�R�$�*5��D��a�a�'�wt���3ۍ	�bQ��Uw�*�N�:n�����_�>d7:�mr�v1�%Mr�~Lh[Z������د�Cߝ�l.q�Z����*�Hdq��i���+1�u��5��&L�S��ؓ����a�Ν�e%g��׬%�ouM6w�X����>ﻤI���@lԇBy�������o26|c��J���B/e={�?���tM��DS#�(���T���T�a��5��b��]�dw�;3Fg��]=oS7A��:�QO�]f�D�d���?$O��$���m>$mȩw,I�(�r�Wv`� ֽ�n5␒>u�C�N��fn���@(ID����2����c+`��5��j-��u�j��oð�?3�A����.�_�����������TͲ�1����f̰�]��������&k嚽.碟$?�;2`8��y���䀭��x�$��Th�z�������T!����`�M��J�UQ|W��_��/gC���<�en���K�^�UR���2�TY3���n�q�uđ'JQ���.e���'�U�TNE��	��� -�A?"�WA�#N���2WT��j�F�������Om�>���N^�^i��|m��ǵՄ9���Tɋ�`�j��{5X�]n�伸!���Ðc��H~�u�b�c�%y�G;xV�P$0]Aef���<߭�G��l�ί)��ֹ����=�����U�Y����5u�SQ�3OU�L����5�86���d�-����ntV�HC���f�^A�K�_)*yV�؏!��_�c������� �����(��3ex�j�D�����ݎ�%7��5��Ќݶ����&��V<��|ȝ��M�Fw�M���RUE��z+�`��k��5�qD-Ɓ���MMtsU���y޳�ɣ�n��}D����Fy������>��t���>��ٻ��r5����I?�6�H��K�ݔ�x U_w�d���p�eY:/��L�Wr��$I�Y@��Ҧ哦�����bI�[�*��0�U��X��e&��,�B��m���gb��B��@;��󥔊�w<W�Z�W��gh��R�\Ji���AR�]]�Ω�5]��9��ߤDH'od?�#������?l�=�/�F�z���|���J�ZF;%2 ���
%��S�&H7r�ꎼ$�A�yz�+�"�}�?�)��ۗ�8��exb��LBBȩ/�a4U� /������J;i�Y_��ccσ��W�oݩ칷�;�������O���x��!u�w%�xV���d�TѶ���S�$��'U��
���$�Ω�5mnl��Db�M�H�>y�?�rɁ�Y�݋������Β
�aS��b��jӐf�*DU�Diw���)xL;鋅�D�@�f
t�&H�*�Цx�!�ڨ���N�D�*�:!J��RI_vS4��x����³�����0Rwr�	�~��!�H�>�A��?t�U
���N��96��Í�o_�V�>��40�~��YJ�J]���u��@� 2=��'�ݦDب�srL��5J��F*�j_��Ó����� � 8��m}v�^��22�8����O��}�������q��%NO������vȱ=L浃�����Y���Ŷʨ���2:���9��Y3 |�M�kz���*��I�O�V�5�-��V1&/5H_n4�b+jK��8�T���<r<��s�Ӿ��^9c"5A�#˄�U��rP�I�D1U�&�ܩ���|T3R��.��_��A��>C���1��J� ��#O$\���5����(J��q���/�A�$�Y�`ѝ�)�k�arǈ6��@��Y��c֟�lk�,�W��7��x�8��|0�or�@�Y&Ȣ;��غ�I���4	,��q���(�X��K�^w�"��(f��Fc�.�s����K]��U6�}�d������F���R����'�j8P�b�Y=IB�^>��Ǿ:����	�l��I��=[ ��m͗VI�`te6f�GNH���#��8�D1�t��ϾH�WK=��	A�?�W&vKs=��I���r���]��MV<&O��!���9(���^�`]n���֑5<!��	j��G��<��J�sN[�l��7'��8�(����9��bH�D&��׭�Z�*�:�·���c���wN�5A��>Oc����T��dN7�/��[|�������Ԉ����NkUE������ʵ[\UiԦ&M���pf��aX���F�n�reV�I��
��	����3=���o�uN�	�Z��p��,r��xPo�����Z�>�\��N׬Y���v)g����C�6�N�A�W6��R|>;��1��k�Q::x��@�]}P��if�*�����f�⇤�Ǭ����u��������o��0��-k�ǚ5�ךwl%4ﱲ0�0Eߟ����wm�=-P���1��p�4��?����hw!��K{D���ȭB��w�dd?3d�]M�Cu�
25*��R�l��2�[I�槠*ԕ�jdAqw򭮙�)OrʗW���� 	����o���p]of�'AR��fǻV�Q���2J#	h�v�3迅��v�Q���yb'�q�5P�R�L�vuR���Kש:jWk����桅r�>�����칒�O~=q�G'oY���ᕤ6�JUݕ��ly�$q�� Wh�3Av��独=��R̗����[͚R�
-�ﳗ+���Z�`t��麆�Y�T�iNc��_�wFF@@Z���A4��-�����a�|G�t�u�z��+l	����f�3�]}���8����T�k[��A�#=��x۰4w4X��M�Q�1s���{��p��P�>T��pC$���G�l;�u��]�7z�e��o��b���TL��=G5<�6��H��=�|�#�R�t]F���UC�Xe�ӹ��7��2�2]���\ZQF;8�ɇ=#�wŁ���h�3���C�NRN.��*��Sh�3�����<t��j�'�2�oЄV"7�+��}�mv�����Y�.�������<�n��Xi�'��d�ΡeY.����e;:(��    &U9�{��y����|�7�	x����#&�����&W+$��E�~繶�J�Z.�`�o��P�Tu�`Y̾B�[f��5X��c���N�	Yu4��z��F�\����(�Z���qlƎ���~V���|]����Yu�l��_��Oz�T�ݒaԛ��gkg�t]nnٙF�"TZ-���u}���u8��������P�|c3I���
n����BJ���I!8
J�1�`Tf_{���=�u�[�?0A��\�!W�40ޔ�<f��$Ag+��K����;"� t7Ch�'��p���ǲyX՚k�9.(�5<�娶t5P��N�.�k^�($�1
I`%��ڥ*���{[:��	���)�F�!
�Q�Z{��z�,���׆�{�L�~�i}����@�	�-���oF�9���{!S�Rl~f�9d+38�vW�/��I�zQѧ��-)��6a���SОl���'<�ea�!����^�h(u��5r-7HSc,�$Fj�a�{���� �.�S6pb����`�qd~�z<��c]�n��/k��U��+S{�)�U�ǝZl�@��,�ӵrӥr�J?R���Hc��5%�߁�n)��?�ǟkۤ*+�����K�y2��]FV��CmEuH�p�ã_����Ԓ�QsS|/_�O>�K�=2u��.̵0�n����Rd�K��j��R�_'�(@ᲄ/�"P���Ͳ�t��G,��0w��ZJ5oM���M���ϲ�tT�yo�܃�*��a�����q�~�8���q�����`DXl���}O��R�%�K����v��B����yp�x�Zp�E�ob8�_�6������V�����SdGQ\>k�	��ǂ���c�;a��<zX�F�1P5j?��pF�E�hy�B��0��=�&��׀���JM�h��R[p~�1̓{���)����烋�.M6���wi�l����p�Z�'���$m���>+�V�~��#�Y�N{���^٩���O�J�~�Q�\�����IH4-Dm� &�M{��$_&��+�Md�t���Ts�8�(ЬNe�8W����g�Se�g��3��5T�MU�tg�6A^.x�^�O�Zgi�'*j=/!Ȓ��˰連dz���$��IE.��
_�*��s�-K�~h����GǜZ4u.)u�_乃S<� ��y&�}\a�'Λ�jM����RzZ�k^=6p1��1/[vI�;�`v���5,�V�1yXQ�s�n�*pM�<$����ř��?��Vf��K���\B���$� ����!�ֺ��#��	I�onp���:�e���u�76ʛ�v��ɸ��ϓ�0��O�˰|��5�t��^!�0��(�x�%���r���w��3��0��ǆɘ��o5��s\1�-L�K�#��?��zS�K��'�o��HUi�x�N�eYn��iQ��&�T,Oj���<{sC�����퇕����y\���D*��[
�JG���a�ȏ��0%S�'�	�G�YcM��syT��g��M��ea0�LR�CՕ�L>����;ve~�W�N��)B����뒄�/uw��(?�Ϸ*����f(�.4�E�����yY6�OwE�	`��%��)척j��TTw5��Mnc>�X�ސ��/V�5*��Y���|��p���O�`2����v�}.���隿<�ĳPs���������F�|�w1�G���������<��K�sU�Q�D���_~Ϭi�\e�J�?���2v�o���������wƦ_���A#��mT�7.
�-�x�(\�Еez u�߿Z����G�"�<_�el�C:�H�y>�:�<aGD.t-�ǲ��'�^�e\*���Q�_�u_6αҵ�n�3"�?�-1'���"��L���o���FE���$����k]P��9j-�$�>�k�,6Y�z�UE,�ZKiWO~�����\��kc��Z��0���n�-OD���77�����ܱ��4��?;6� �'�'n���I��,�i%��s�R,��xwi+A�I}�؞g��KF׃	<ڨ���k����$5a�|�w�w:ہqIP\[���'F�s(�@�T䟟���_�#��Z�wZɮ�����UT��[Yv������V��H�l�3w=ù�.�֩�����T�i?Ba80
� ��i��<!���fp�K��^ƾ� AURV��䂫��]vl�]��P�c�;�zqIvׇ^-�>��EQ*%� ���b{��	��<�B�=�J8�7Ƕ�}/��,��63mÈ>Wf$�ۮ�z��J�gس���	@?��S�i~���?�����5;�-Vʳ�X~l��RK��Lg�;8M�R�wU�i2PR�
�'��
�d{V�%g�<�E�H�շհ��hdr��Zj�ٟ�D��MP쥊o��K��]�v
,-qޞ傓ܻ�v�����E��<(��O8U/O��O]����-�o묗�4\�e��;S_��l��!P���$BrOw��]�)I���f�?��D|��܁�l�
Dc]���_oư8�挵L��0�s����4�z.�ͳ	�#��gų
3���*p�^��
� <�TF�X�]m�b�y~�kԸhe�?·�)����9�YW,ŉ�p[&�Y1�Q�V>����ŏ����{E�d�DˡZ�����P�aq�c&��@H	�R|n�������MP�,��z�4@L��a�\N��,�J�X˺�t\ۨ�/~�ev���,�s��<��*�H�!u�Ǯfܱ[�Zޥ1��Hz��$�t���v}�aе���%ɜ+��0��(w�q����Q
!	��+���E�n��(�*d_�c�c�Ե�DM/W8D_�S�i:*�~�H�;�	���|'�Σ��j�IF��}F��Ο���d�2ZM�r�:�珝��v?��ӗ����WX�|m�2�ӛ�\3Pt�u�Es�f�ﴷ�e6*�š۫����G̓�Gރ����Uj��O�x�L��G���R�!�DB��#�Z�I�2�&p��X�_�/g�Ǿ* :��|h��hm�ίߔ�k��Q�؃����^/���W�Sn�2_l�}f�g'(y��0�7�]4m�͖�_�$-��1AYܙ��x��q4���ġ%~�q�4�K\����h=���Os���U�*���h�+o�r������j�;R7���;�s�u-�S��o�Ĉ{F��u���%���n6����Y��� �n���<��//��/hP�S5����o��N��X�� �=/�Bj#�J�И��P�dS���V��:J���,Ǻ���!x��cX��X�|��5`�M�\������~Wַ�djY{�����3�n���w�K]����m ��8	K����c�w��g-�k�mbe�G
�� 嫰�f��X�,�������҈��jۦ���'�@��ɾ���6�-Q\C��,k�7?�x{l�JvX��|���H,�8N�%����pH.�D!��������S�(B�<7���I�ۯSn�r�s͛�mCT��0���l�F���K��,yz���7��Kl^�*�0��E�N*�l�E�����CelO�d�!�2,��)�n���|�dV#��5�n�7����>�4{�ER���o��us���"�q�׼_��N���m�R�X�Õ�'���gLR_�K#�Rξg��@� 5(4�0�n�"�C6G�LD�@�U{�R6/K��,�k&��ߨy�
b�%�!���*~Z�`5��R$�R�֎j���شj`��F-v���p�.r|k�Y�{%��]� �e�,DT�n�zMS�4�ʻ�(/�<rRt=3�ѥ-A�9�Iו�H ���@b��<��s-;e��J�R9�w�x,(u�:��
d��|�A;Q[�f�M�4no�Ux����-��r�������M!�ЮrN�	V�Uo.��(P���{� ~�w���꺢Ys\���s=9>ڞCx#��լ�#7+l�J���oj�2�S^E�B��ԣ�$y�Z�C_����&Z����_��_�ef�j�J6^�f�em��ʦ�6�MQ�i����B��GD�    ���jy�Q��]jwf�*o���QjY­�M^�ƞ�R��?��av�j��φV�ֱ�m�*�]r��t>=iUc+�0T��@Oj:�_��{qv5˪\}�_v?&��vi�U�,,/<q��D׈g�O9������³8F���K�y�`��v�vK]W�[�(L�Ղ��l�H��NuЋu��]��h� ���^f?{/�>��ea�Uu���#�:�N��&��N-�5���S���4�v������c�D@�^"��]������A���V��*��-,|�q�'����[(��d��nUO�̴ɣ�u�r�>�{�����ǏK@YV����b\�Kȁ�����LݜUgi-��}@�G�ٗ!��yo��d�x�I"���!��Yu�����$O<Wh$���G)���|]�����q`�-��?��<H�![�eo���k	7^�h)ZaH�׉%C�ݳ��~Q�O�[*RY�D�9R\�41�.�z��3�6Z��!��˞q��sB�\�����*g��� ��p�HlMrW��J� ���������o�uu�4���m�n��&�5CZ�.�?���t{]Wϋ|zƫ�_,W%I������}�T
Z�V��]j	�*�Ž��̷��y��F��RƆ�����=L= �)0�H�I4��\�`T��_�`u�ꇸV-b%��g��噇G�iye�ʲz��tjAgH��	E��@5���/Q��	��)6�����ù܁?g���3"��6Z�|�|tI#�˱G�ߗ}1{sF�p�X�ޢ/W�2x'׊a�!��V����$-y��e]����_=����_����D����:���$V/9E�U�UT�󽔞T�mL�h�j�N���D��/��Cߪ5l�z�uM��<g�)y�t�� Y�C�M��Yg�u�(���3j:�X�1=�7��$5�4�:y�:��hv,�Cٽ!H��-�>�盭�֩TZC~|�����$��ъ��?���}�7|��躮���uv}<x)^qx[Ex�q���r^��j��Ų� 2|�K�lLy%��@�Z�O
���`u��a�_��V�&�L�)�m�����^Y�4���qӆ�������]�
-+xf�Ѻ\�R[K���7�ޘ��ij����,���nV�>�.�z��G�< ;U
��=+��})�X{v~&X�olc{ �Qə��#�V��0�R��NS�����&صdNE��jQ�ƦY�nA������ޘ�1n����Fs�W%R��[���'ա���DR?u_���Qˈ`��}b"+_��?��������xP�/���l7�����w�4�(-5��
�m�p�,��a�X�0$�	�l�9�
��*3H?zl&X���y3y��*�1Q�%rm�p����(�RE���Ѻ[ۉ��U�(��/�U�A����~��z3��ȇ���s�.~����U=�S�l�~z��\�����j�b+�,֒+N�뺾B�&�x�}D͏�͇���*�Ǻ�\�/�9"�.�9T=�H�uW뺂��t�����!�t�r�ȃx !	�8�g���߱R54�Q���xE�w-�-�HP�\a���~ɲ~��S�+U�;��N��M_6��U�$SfY��%VF`m�$CI6/Nj���oL�������z}"���kW�g���2g�b���N"ͳ������J�l���_!��N��u����|�쪞A�#tʮ��B���țS&��S��l�wt5�����j�G���|����m�fٸ��?l�zT&�FŊ,�dOC9xu0�f�rd��h�����>p���\E�z�	�oe[{�ht��yS����4�Ф~$	,�גЕ'z�����\�M�cX�!�?�2r �uփ�(MW��لW���.��vU�:q������nt�D�iVlA�J\R���_K*+��3�D��	6�b�{�?Ysv��.����i[���n�ȽI�a{�����J�KC?q~��
���κn��p��UQ��;s�
f�����$_7F�_��7�y�J��	C5�?j���*�əh��y�}�Tf�����\ �]ݨ��$��&�C{Ƴ��D���7����go!�X�xSLS�OA��ުL��heC��U�{��ᦜ*����S��H��Xd�5@��;y��
��j!��N7�@�q�FI��EQ�_�V̙�l��� ����Đ6�oU��}o��g��d&�l������<�0�":�$v~�#���ւ���n�����V�ܪ$G���1��W?���o9�_�#���f{��N-�D��\%�@�x��M��U���`[��ghW��+���7�(���3�65��������V�.f>M�
�T���z���N�᪝�K�zC��I��>4���K��V.m�i�\����W����ݰ�_�w����p��7�Rl�}������峙�l�����q�ɉ/�	� �p�aˤ_��Y�m�y��,G�du�?;fZ�K}�l�R�NU�l�j|�i����5�T�~"������A��$�o�ź����W��<� ���쳑���#p��]7��$�y%��Б�hD�l��.�kMHwl��Z=���Q�,L����4e�5��6�</�y����2�Q�r�Y1%���Շ-[)�3�z6��40N��D��a���G���U��7���C� ���|=l���^ѱ7W�r>�9�u1������4x���sZ:U�����,wTp��� jg��>ȣrg�j~��1��ԱHr��Qn�z#y�ڨr�m^U�V���p�������]72��%۰��0mڲ�r��)��"{���L��r��k�+�g��f�(�J�K�:��s��9�-K\��FD���<pj�r=�M�����d�*\`�3��M�$&���F�}�=4��F�B8�u���Pd��|���S������`"z|R�"�����"wR|��3�4vdP��ѥTQ'�n� �۰J���u����O*Y����W7Y��ZT�cȄ�g�=���oҰ?d`�dWSs66��ź��Jޝ�r���X)�I�a}��.ۣ坢��5��ZN稯鬫�E�I}W�	�۪v�f��E;�AKoW�֑�0G*�Y6ַ:c.א	��g����J����-$�����#�ê\x���ҡ�0}���g }%�I��ب2�kug_%Bp���	��۾<��PKIJ�;]��دqt�yG��d[R���>;��^ۨ�,������"���?�N�Ό���"]�aUM���0�PQ�-c�L���Um�w&���q���^�/Ċ��FV����v����Im��sȠՏ��7�r� Vv�KT�5B�Q�H�Ƹ��V����������f��[]!X���:���y!).�=�r�ƍb����T��s�/��Ԏ�C�7G�˻���] �gڭA�݂�#+�r�
�H��3��)��MS:rm�R�1u\�A����Иq���:ȫ|��Z==��
G*2D�*����L��3A�?p��G�/ ����w�wϲ���K�9En�j���;cvS���7�؏��;�,o�d���0�>��]iL���?w~�
��ީ��F�e��s���K�f� V#W�ˡb����]�J��F��u���b���aR�����:���T�]�ӕ��;�T��-EF{��"���".��Տ|W>"k�w�o*w�Mu1��36��7ӭ�^������S����TuGj"U/d�W�2��cL�!���ܒV��L���`;Դ��VA&O
�v>��\�7�a���n�{�ڹ�Z���2Zd���#-�$�$"[�`�Mĩc���j$��]G.^�G�Og��u�|T���V��v�Q��_:6����C�����T"��r�8c� ���~�q�Hz|xQ���mxgqk�#T%�J���=yt~�<��6�6�-�|4` Y��1fuk�Z���F�x�)��:F_�TNV����g�[=��׬����k(��o��Q���W]���%3� �V�A��ׅke�#��b�� Ċ�l�(_��u�M%8B�_    �M�Iޣ2����%GYw�sa��rQ�R�6����X[����sޙ-��%��|�%����R��5�(J��$^�>CƖ�@�mq#�)��$e�I�����g����n�iVZ�<���`�AJ���jc��jb�:���v�
�c����?Z�dή��v�H-˨��4�^�%q:#�*��|z0��Y����݇P�]c��㭱#��%˝����j:?�( �	����A�T��l	-��u��oy�` ��aM!�z��?�#�׺n�fA)�0�	I�0�LE�� �.�u[�7J���i��V� ���U�1���b����dF����e��Vv% �e?���!�ٷh��_��g�PJ��ӯt�v5�Z�ٕ��ڂ�3���ۡ^�I�')m��[�_���U�uR ؑM��� L��4Z��Jl�n��5�� � �O����!~+Q4w�F�m����>���NX�B>�ٷ���}�a��v�j|�V�NeN��Rh3@��#�ԚYr�zm���J�K;t!ܭP� $��M�`��y�/���XV�v�+Y9_Q$^d:&������6��;^��ku�>ߍ�.��� �('���ĸ���A�v��F���Yn���A���Z{�hy�]�T	D58^���ǣ�u������eD��~���'Ii���u{^�+-��Cw@2�T����<�S��V4&ؾ,�Mw���TF]��7K��f��Nr3�ae����γ[5�cu׈�=�VJ��=J�K{Ps��v����~���Ǡc_�>ۗ�v�;]wލ�cd7Ľc��Iv�����e'��YN��	BiԪA<��(jO�>�� �,���Y^h�7h��yJ?4.}�JGʉr"�5�@ua���u���|/��)In�]t���Y1)tx5����w����]/��d�&�ŋʫ^���	��Gyd�U����\��~�/�.���(�&���u��3��F���F������`��Wj���C�UI���F�l!נ�@.?n�� �yV�F�O:���/���)�g�1P��qu��棲��ն�|t�?�?�,v����ӹv`1�m��h��!*�����������>�`�]��/���h74�ω�Ȝ�s��^S^����սab�)&SE=�F�U	hʍ�����n���v�G�F�L�l�n��8 t�����;�8,%�RS�IW׈f˕��`��z=�>�E�1�뮺V�l+�Q$��h����ݱ�G������60�VL<ϳ]l��?��v��Ϫ����׶��Q�Q�K�m��:}�Ӵ�����꫉U4*�ʏ�.Œ���K�w�H1��[c�k�r!�8꣍���}XN-�y���^�]{;@�PLb�ڊu�&���h�U��5�]�����ĺ�d�L���˦��(e�&�}���l�,�G"��5ЏY%m�@	��t�	N˦\��/3��ɿ����ҁ��0��'����;V8y���Iȳ���Z�F�T.�RN��֪O��3�n�A�vn%��-��glX��i]*��`�w��g@�6�Ч�o����//<.α���x_*�$x�y�gQ2Wlex�����Ƃ"�"���Y!�ٝ�!~��"P"�O�[&�M�����A"�u��ԕ_��a���~L� �A��W$O<Z1Hw�go���ʱt�lw�;Ue���*c[D�/�ZJ���:�&ؽ�ܕF�/����T��c�0օ�Y�a=_������3#X�H_��c�n3yt�a���l��M�.�l�u��VMUW�Wz����ݟ����mn��nL�U֫��ɼ�ƺ�|#On�l7���E�Hm�Z����#E�U2�}���r@�^0AL��#�;���VKB���Y50��S�Q�E�I�:�O���*��(�0T /�h��)S�ZGw�e���� -S���k/wH���/�ew<��)_�<�@:��$�KO��y~Xk�\��wR�=Qi�bƥ��V�My�q~��6s
�h��M9"�T} �8ċ�u��s�/�]��٩A�-n:���cO��sxz�? N�F� =����w�rq�_=� \�Z]���j(�	K9�:�<&��W�[#!<�	&HX9�\�q��{|��Ž1slox��U�m��чٗ�Q�ֵ.�Ԉ<��q�X�����.Q�3,%Ƞk�Z�)�ܽ��\��0@6A��n%��u������Y("�X�6S��_�a+Q�3����,Ψ(O�����LCc�ZCL�ˮ�שˀ�����H]��Bm����1�f&�����{����U8:}�WN9/��8d��1]h枭o`�x��2B�DΛ/j3���s������\M���ƫ}�U��Zn����b/_�f���+������4�����|��UXۨF���CL 4�Ca$(��V&7-	$�FE�)6&����kh�Ɣ�0
LS�-F ��5�l[�&���ߑ���e�����`|���Sa���ASǠ���U��QҒ�֪�sY�\ݱԽ�JR�^W �˟�q
]�!d#�o@GT���Q�?���5#b&�"��gH�Q�e⽵���=9�o��|c쫩���a�N��i1�>8���G�sʊg9L��]�b̀�f�j�I�X�����i�?ߐF�g����c7A�r�To9���N�br��=*u�2�~��N9�Ze�]w�\Z�/q�C���W�
Vk*����\pZ>��t8;C�R�oy�c�De��U�Us�^�l�l�>\����������������Fw.��� �(��Ի1l��#�r�_*�j	;\պ���1|���W�ؗF���#F*Wg.�L��>TLEI"1�@I7�Uo'��'*���!������Y�����b� ��\�_���w��	 ��f���FMp��zv�o�~��ziVm'��s'K��;]�p
�/�oF�!��>��vv2�m�&���6q����
������6H�8g�4AOp!���+ �JǓb]����^�&�W���	�ܷ�A�����,�Io��Mǀ�0�
��<�Y����	��mPh�z	h����նz�<�͎i��`�f�.4�ʶ]�Z��� XRy	������j��R4a�O��J�#��=V�Sh��5g�Oz�۵�M!;���u874E�g�-�?e��=�Ku�QuhД^�g����\��0A1}�z�#~�􅍚�Ԝ�R:H��*J!�f�>Yӣ�Yp7�a��w�ң�`�/^���u���6�Jn��\�m��>���/A��3s%���\�u$�����<���A��W�s�O+%n ���d����^I�^��f���{�1*�����_�,��^)���X�d�G7U8�[�s%W�\M�	��~��녖���Bp��~Í��@��i��.q�L ������@�3>Q�n�W�4���iд��ӓ�t�{FM5����-ۋ�S�l�t�]MS�&�<�Ws�U��=u�R�N�Ե�_;G�67�X#���Б��c�B�]a��i��L����]������r�-)��D���;�z�~������-��\P �W��>í;y���p���P��XA�򜼫��Rj)G�	y.�|0As�*�����Gh#s۶�)�Hn��y�̯�D��.c/t���urT��tm��ȴ7��HI S<���}ʪÑSam��t�TM- (�*	A��R����op#��nl���rf�uhQ7��R�0���R޲Syh�����F����̳>�0n���!�""Y_�nI�x�7A�r-�b���>�ʣ"���1��}>nڃ�,�ݺ�M���{�¤��*#MB��yٱ��h�`��gy[r8T�=��*��,'ߵ�^t|��MA&��7�=�=�T����ַ�d��=� !I���A�ȉI�����#-,W�~C`������Z�A�e>p�U9�����Y��M�gG����|(&4f�)��Ij�<��Ș�K���7����~R1�>�Nz���ͤ )Wΰ4A�HZM>6���іÚ�{A�9_U]s�!��lv���o�{E�h��t�ţ"9Z��
���ހ��R����mvmm�    L�,��7�d��r��*K��/�9ڣ��9�=rY˥��x���.�Y�W6j�f{���N�T�1�Jl��q��9dc���p�G�{ .gD��PV�y�^�fi�ۧ&�
��K�W�P��@T���r�k���K;$I�.��!K�|��`�7A�~$.:�"c�%�>y5�ۛN�i0A�yz��?�9u���\�,$ؙ�׳�	�Jn��<=�E���W�g\ñT]��T�\������*�Hȃ��I���ݳ�Jzǻp8]�v���w����rEe�
�J_Rf߳v�[�<���o2��nBWu�S]��S����V?��mCq9��F]PkJx��I}9��Iz38������h�����3/�p��m��v���m� �>�Y��y+�V����w0P�#�k��a����jMkht����}��R���}�Byc-F�,LЉ�iTJ�;Tֶ�>#";����13�}wn�=H�ܔei�)�e�_>]v�LMmH��W�����&hW���#� ꑝ���@��,�D�"۳�G���L�&?�p9��	y�E<�ٝ�����3_�~�>/$��@��\ i������y@[�H�O�О���'<��r�>�A)�+�SiMڱ�A�1>ư�q�N,8 ��Fy��ȭ7��E��2�煦��eW�[��H��ݢi�>^��r��cؾܵ٬󒧖'��)��h��+v�rm�n~-�k�{��U��N�J�rv;�������1��)��	�F��|�D�����vv�{t�bUgϝTof�a��r)66C��%��*#�X�����3�_��dL�8�V�%~i������IP��7������zǒ�}�z������]xKu��(*��%����`�:]�gc�ESFDh�.P7)�C��҆P�8t�Ĭ]� �K�����)�~�訄b4S��s[tL���.^�I�O����ʹ�d+9�*��Ko��Lz�5U�!U�����])�&3A�- �u�>t�m�����Py�|֒*!=�4Aw`	��*<�'O���}Y+��r�Ŝbo�.��/ϋb!0�#D���F9�t���0kWܻ��_�*GQ��R�ɯ�+���j��Pm���P<
��i�� �e��Jg:�X�ΟV6�V�|���ag�1X�{'�\Gq���7O�n=��Ybl;���7����Sv<l*�D���i�!�Q�y��*�		ex��*���?|��xp���]5U�-f�@�AJ���	%�UZ�D���J ؀@a�tm�n9U���z�l����8�%Ӌ/�	H���M��B3:g;�M�շ���g%� �;/�g�,�2)���k[������7�!�C���ߎ��Yُ}6Hݦk�.2\���	��U��T�H����v����y�Tƒ窻�H0ĬX��|)�b^��P��������Iu�Eӽ��j�P�
�,�M���ajFvh3��)�4�C�W�bri(b�Ƙc:� wVv���9���/�&��EV`�*eo����Tn����� ?,[�r(0H�Us�'�UX�gX�c)����ÝcW`��������ܶ����q�ڨ;�
ɨ��.ߏ�FcN�\u���t��T������(�p�w ��Nm���=�Ӽ�t��R[9x��j��%��)6�D?�������X���mj�!�}��l^�P2�[v��8^�_���z�
��?zHA�QcZ+�Z)���Q��d���+�u�Xj�#Ypx�R�R�J쮇A��|� ��T����w��߲_Ԥ�ո/c`�=��%޻�}�jB?&U��9�v��J�=A�%4�{ʷ���� ��#=�H�&ʭ3��g�z�9�`�/6��4�|�RTL�N�>ĕBE�G�Թ����J��:����]\��+]%7�
􍚃��Pi��s��+�"��gD�=�����#oW�뺏�Z�
=e����uh+�~>J�m��>�23J��ĉķ�#{<�n�)@����t�'���3� lP<�j��C��gԊQ���>}�S�-��D� ��s/�~�P�3�u�g����(������q@�ޕ/�̖x������q�Z�16ԁ?�|&/f��YR������b5z�h����E�ᣑ��i������23W+)�݈��%��
S�f������[,dʝ��g�v�o�![9yƲ_-��(��,�ߋ;��Vv��j���`��<3|.��+9###�Wp�� dVؘ�����* �o�M�O�ٯCB�����b�!|��zs���K���F��M�<����F��?v��8;Š�~����lJWj<1]�-���D���E�e&"i�w<�F�1����;�]�|{��  �׷0��g��2�U�R����eZg'�t2����E����Ծzn6�[I������v��	��m�U|���KWkC*XES��4�h�-�ȟ��FBr:z/z-+)I���bm���ny��HY��"�WC�Q�5Z���i��r[$
�A�#$�B�^
��^�س#o����ͽH)��B9�3��=��Yau�M�&�����+������	��$)��â;��>_�b:����'+ҡ�6��jK]�XND�Jx��J��7�a�-�R����2��"`�O�?6�ǓT���s��F��#�R�f�N�Z $rwr7�ڵy�;�V���ۤϸ��a����O����p�B�-7���J�28r�w�"�Q`�[�ƿ�2?���u�S����T���1csd����N�%���qT���ۦ�%��}��c�7���ɝ��]�R	H:�L�ڵ�z�u�ֽ�	���#���;W�9e�`��-���F4s� ͞��A������9�t�:\�a����N���<�=U�P����&^��Ǖ�V3q�z
*L�Im��M0:Q�?����Nu�s�L��)����K��FW��We���-����h���<�7m���[#y�B�K��^)cRKAE4�{<%׃���#t������#p
I���v��)�f��}������s�����e�4].�Sv�Ҵ4To<��]��<&n`X��������ōE�I_N��T�rX�gs��)�59��6��j�c��/]E�u�#u��������4"�Ǆ��s�])Nͧc�:�%~*�����R��E�g'�h��K\��,O��{�{b��UY�9�u��g�T��i���ڿܼ��Ѳ}� ��3�ЃS�t}����C�ȸ`��t���L���=��FO�"�V嫇�8��	�1OMf�H�P:�C�;���c�t-���*QF}��K�\ɓ�VG�K��>�۪yE���7N	�f��Kƀ��x6N���O��û^�x�%�)G]�Kw<T��s�p0���YP{W��uv�0d)�6�����d5{]�ZX�ju5��p�8���j������Y��+�d���-�|��	ѡ�����i+�Ì�[���	�X���[��q�[���i��p1�x�
�`<G�(�^��*հ9���l�bK�te�T�/~3_T�[!C}���E���=�a�L�&�^���I�
l��	Ѽ6��a����r���	0^T`�����$�e_dN���t�ʃ�N�o4�y\����E[����R�����9l�v_�0�v]/���Z�{Y:��>���.�U=�J�T��9~lE�к���?3qg=��RT�=�_�9u8WF���2�m*p(�0|.+)��ey:Oi�Ɉ`LcP�a�˫z�Q�]�+���w)���{��$-���|��v����_s.c�ꂅ!C�y�H}�����5K�^k?��Ja��6Y$��[9�6tkU�|wn��{`���n$�lp?��w�[%�E��uv[���4T������.��J>�������̵�� _�s��v����hvֵ���$_VM�R���LՏeW�2И�}�^s���ѽ{Jj�B�������� H�����sh ���zsr��򊍥ؗ�Do��JN�z�Q�\���4��K1�8��G�4��(/�=��e��_�}
�)�R���� �  f��R5��е�^U�\�S�z�|£�#;M2�4���r��m�9��X��k\K<qc�MH��	���1��=��J%��-&�"����.u�+�8��x�<��)���m)W�Z���M>}���>�8�M����e�kV/��G���;h��A�
��
��֛�A����W���v,0�K^�rh7�i�pt�7���j�F)�� ��81�t�_��Q�m�WW�N��"�M��<K��������v!��ḟ�A* �? @�w%�������~�ȑ���$F�+AP]$"�v�}o|���K���6��{1�d4���
I�;׳�e�|�9m��t��J%�J��*.I�G�����%��Y���M�`>&"r�)�'En_��"�zk0a�������6i#�F£ /?P(���$������Q��J-=A��_ծ����J�b�$#�g��47��Oq'f��$� �$�jV&��EF�:�����ϟ~���� �      8   1  x�]���9D�u˗|�f�N���=	R������\��|���u�^����c~����5�«�6���������e}���x��*������:���kq���-�[�,nYܲ�eq��������������q�Bl!�[�-�b���Bl!�[�-�b���Bl!�[�-�b���Bl!�[�-�b��`4F��`4F��`4F��`4F��`4F��`4F��`4F��|3��U�\�~��Wx�����zy^���[��[�,nYܲ�eq���-�[�[�[�[�[�[�[�[�[�[�[�-�b�� 6�b�� 6�b�� 6�b�� 6�b�� 6�b�� 6�b�� 6�b�!8���Cp�!8���Cp�!8���Cp�!8�|sn	�|~9E���"VĊX+bE���"VĊX+bE���"VĊX+bE���"VĊ��hc�1�m�6F����hc�1�m�6F����hc�1�m�6F����hc�1�m��7�ϯ�A�A�A�A�A�A�A�A�A�A�A�A�A�A�A�A�A�A�A�A�A�A�A�A�A�A�A�A�A�A������������������������������������������������������������f��U�b���A� v;��b���A� v;��b���A� v;��b���A� v��]�.b���E�"v��]�.b���E�"v��]�.b���E�"v��]�.b������~�����_�~�����_�~�����_�~�����_�~�����_�~�����_�~�����_�~�����_�~�����_�~�����_�~�����_�~�����_�~�����_�~�����_�~�����_�~�����_�~�����_�~�����_�~�����_�~�����_�~�����_�~�����_�~�����_�~����W�_�~����W�_�~����W�_�~����W�_�~����W�_�~����W�_�~����W�_�~����W�_�~����W�_�~����W�_�~����W�_�~����W�_�~����W�_�~����W�_�~�������qKP	*A%���T�JP	*A%���T�JP	*A%���T�JP	*A%��J���;*bE���"VĊX+bp~-�u�����O�����/��%�#�I�9��8��a6�q���lf�0��8��a6�q���lf�0��8��a6�q���lf�0��8��a6�q���lf�0��8��a6�q���lf�0��8��a6�q���lf�0K/�D��K/�D��K/�D��K/�D��K/�D��K/�D��K/�D��K/�D��K/�D��K/�D��K/�D��K/�D��K/�D��K/�D��K/�D��K/�D��K/�D��K/�D��K/�D��K/�D��K/�D��K/�D��K/�D��K/�D��K/�D��K/�D��K/�D�������Ǐ�x&��      9   �  x�mR�n�0�O_q_P��-�k:�S��c�L�)��|D���.Q� H#A�QC���I)Rj� $�w��G`QI\(�Q�n#�;�r�T(y%���@����q��C�PO�<)�%9Ё��έRmE����s(x�:K%�HH5u���l�-�͉ 2���ݘ����i�$"�}���+�l�kǓ}��ɑY}-a�m	��W��g�L��3q�Ñ�p_�˻�����.��W�es�T�'��qSci�Sq��7�0������^7q��_��9wZ'�2o�f�0�l/�}�}�_�����0���Y������{/�y���>l���.^�m%�K�&��f��O֓�Y}��u{D�d�2]c�d�鈎:hau�zp܁�'n%b���5�b�ʰz���<*R&�H�=��)��W�P      :     x�uR�N�0<o��?`�]7M{�*񐀢V��M�7AN
��g��p�X��H3�3����e�������X��h"@0�;��GFp�mۨ��mk;ԁQ�u^	c	4��	,*���XU���	a"pLL*P����{V�<��6�} ͥ@ R��L5�pg]��v�j�n��!15�O8�ÉwV�����S��������~��7�QO^lع��B���T�$�L�\��b}����)�L#j��9�v�UW]ׇAP�󹦀�kVo��f��u�AO���8�]�D~�����1��3��u����	�&�K�/� ���WV]�m��8�К9�����!c7�d\��8�Ҥ��L!%N|d�kd�i�d��5qM��,˾�r�$      ;   P   x��̻�0���<9~���s`��"'�ݧSL�CҪ,(�E��+��� �HqA:Z�C֟�AQh~(1�E�ID'�      5   @   x�]ɱ� ��`�������ϑ�Z\u���n�����4�"`����6��+�U� ycA      <   0   x�Ĺ 0��&���d�9���S�_H�nC��M$W�^� ��F�     