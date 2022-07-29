PGDMP         5                 z            final_project    14.2    14.2 5    <           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            =           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            >           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            ?           1262    26085    final_project    DATABASE     n   CREATE DATABASE final_project WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Vietnamese_Vietnam.1258';
    DROP DATABASE final_project;
                postgres    false            �            1255    26170    auto_price()    FUNCTION       CREATE FUNCTION public.auto_price() RETURNS trigger
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
       public          postgres    false            �            1255    26086 <   booking(integer, character varying, character varying, date)    FUNCTION     {  CREATE FUNCTION public.booking(table_id integer, customer_id character varying, note character varying, appointment_date date) RETURNS character varying
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
       public          postgres    false            �            1255    26087 )   cancel_set_table(character varying, date)    FUNCTION     K  CREATE FUNCTION public.cancel_set_table(customer_id character varying, appointment_date date) RETURNS character varying
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
       public          postgres    false            �            1255    26088    check_booking()    FUNCTION     
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
       public          postgres    false            �            1255    26089    doanh_thu_ngay()    FUNCTION     �   CREATE FUNCTION public.doanh_thu_ngay() RETURNS trigger
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
       public          postgres    false            �            1255    26090 N   insert_customer(character varying, character varying, character varying, date)    FUNCTION     �  CREATE FUNCTION public.insert_customer(customer_id character varying, customer_name character varying, email character varying, dob date) RETURNS character varying
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
       public          postgres    false            �            1255    26091    nhap_ngay(date, date)    FUNCTION       CREATE FUNCTION public.nhap_ngay(start_dt date, end_dt date) RETURNS character varying
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
       public          postgres    false            �            1259    26092 	   set_table    TABLE     �   CREATE TABLE public.set_table (
    table_id integer NOT NULL,
    customer_id character varying(13) NOT NULL,
    appointment_date date NOT NULL,
    note character varying(500)
);
    DROP TABLE public.set_table;
       public         heap    postgres    false            �            1259    26097    appointment_table    VIEW     �   CREATE VIEW public.appointment_table AS
 SELECT set_table.table_id AS booked_table_id,
    set_table.appointment_date
   FROM public.set_table;
 $   DROP VIEW public.appointment_table;
       public          postgres    false    209    209            �            1259    26176    chucvu    TABLE     �   CREATE TABLE public.chucvu (
    chucvu_id integer NOT NULL,
    ten_chuc_vu character varying(50) NOT NULL,
    luong_co_ban integer NOT NULL
);
    DROP TABLE public.chucvu;
       public         heap    postgres    false            �            1259    26101    customer    TABLE     �   CREATE TABLE public.customer (
    customer_id character varying(13) NOT NULL,
    customer_name character varying(50) NOT NULL,
    email character varying(50),
    date_of_birth date NOT NULL
);
    DROP TABLE public.customer;
       public         heap    postgres    false            �            1259    26104 	   doanh_thu    TABLE     T   CREATE TABLE public.doanh_thu (
    date_time date NOT NULL,
    revenue integer
);
    DROP TABLE public.doanh_thu;
       public         heap    postgres    false            �            1259    26107    menu    TABLE     �   CREATE TABLE public.menu (
    meal_id integer NOT NULL,
    meal_name character varying(50) NOT NULL,
    price integer NOT NULL
);
    DROP TABLE public.menu;
       public         heap    postgres    false            �            1259    26181    nhanvien    TABLE     �   CREATE TABLE public.nhanvien (
    nhanvien_id integer NOT NULL,
    ten_nhan_vien character varying(50) NOT NULL,
    ngay_bat_dau date NOT NULL,
    chucvu_id integer NOT NULL,
    heso integer NOT NULL
);
    DROP TABLE public.nhanvien;
       public         heap    postgres    false            �            1259    26110    order_and_payment    TABLE     �   CREATE TABLE public.order_and_payment (
    table_id integer NOT NULL,
    customer_id character varying(13) NOT NULL,
    meal_id integer NOT NULL,
    counts integer NOT NULL,
    date_time date NOT NULL,
    price integer
);
 %   DROP TABLE public.order_and_payment;
       public         heap    postgres    false            �            1259    26113    payment    VIEW     7  CREATE VIEW public.payment AS
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
       public          postgres    false            �            1259    26117    tables    TABLE     ]   CREATE TABLE public.tables (
    table_id integer NOT NULL,
    nhan_vien_phuc_vu integer
);
    DROP TABLE public.tables;
       public         heap    postgres    false            8          0    26176    chucvu 
   TABLE DATA           F   COPY public.chucvu (chucvu_id, ten_chuc_vu, luong_co_ban) FROM stdin;
    public          postgres    false    217   �I       3          0    26101    customer 
   TABLE DATA           T   COPY public.customer (customer_id, customer_name, email, date_of_birth) FROM stdin;
    public          postgres    false    211   "J       4          0    26104 	   doanh_thu 
   TABLE DATA           7   COPY public.doanh_thu (date_time, revenue) FROM stdin;
    public          postgres    false    212   jW       5          0    26107    menu 
   TABLE DATA           9   COPY public.menu (meal_id, meal_name, price) FROM stdin;
    public          postgres    false    213   �]       9          0    26181    nhanvien 
   TABLE DATA           ]   COPY public.nhanvien (nhanvien_id, ten_nhan_vien, ngay_bat_dau, chucvu_id, heso) FROM stdin;
    public          postgres    false    218   d_       6          0    26110    order_and_payment 
   TABLE DATA           e   COPY public.order_and_payment (table_id, customer_id, meal_id, counts, date_time, price) FROM stdin;
    public          postgres    false    214   �`       2          0    26092 	   set_table 
   TABLE DATA           R   COPY public.set_table (table_id, customer_id, appointment_date, note) FROM stdin;
    public          postgres    false    209    a       7          0    26117    tables 
   TABLE DATA           =   COPY public.tables (table_id, nhan_vien_phuc_vu) FROM stdin;
    public          postgres    false    216   Pa       �           2606    26180    chucvu chucvu_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.chucvu
    ADD CONSTRAINT chucvu_pkey PRIMARY KEY (chucvu_id);
 <   ALTER TABLE ONLY public.chucvu DROP CONSTRAINT chucvu_pkey;
       public            postgres    false    217            �           2606    26121    customer customer_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (customer_id);
 @   ALTER TABLE ONLY public.customer DROP CONSTRAINT customer_pkey;
       public            postgres    false    211            �           2606    26123    doanh_thu doanh_thu_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.doanh_thu
    ADD CONSTRAINT doanh_thu_pkey PRIMARY KEY (date_time);
 B   ALTER TABLE ONLY public.doanh_thu DROP CONSTRAINT doanh_thu_pkey;
       public            postgres    false    212            �           2606    26125    menu menu_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.menu
    ADD CONSTRAINT menu_pkey PRIMARY KEY (meal_id);
 8   ALTER TABLE ONLY public.menu DROP CONSTRAINT menu_pkey;
       public            postgres    false    213            �           2606    26185    nhanvien nhanvien_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.nhanvien
    ADD CONSTRAINT nhanvien_pkey PRIMARY KEY (nhanvien_id);
 @   ALTER TABLE ONLY public.nhanvien DROP CONSTRAINT nhanvien_pkey;
       public            postgres    false    218            �           2606    26127 (   order_and_payment order_and_payment_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.order_and_payment
    ADD CONSTRAINT order_and_payment_pkey PRIMARY KEY (table_id, customer_id, date_time);
 R   ALTER TABLE ONLY public.order_and_payment DROP CONSTRAINT order_and_payment_pkey;
       public            postgres    false    214    214    214            �           2606    26129    set_table set_table_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.set_table
    ADD CONSTRAINT set_table_pkey PRIMARY KEY (customer_id, table_id);
 B   ALTER TABLE ONLY public.set_table DROP CONSTRAINT set_table_pkey;
       public            postgres    false    209    209            �           2606    26131    tables tables_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.tables
    ADD CONSTRAINT tables_pkey PRIMARY KEY (table_id);
 <   ALTER TABLE ONLY public.tables DROP CONSTRAINT tables_pkey;
       public            postgres    false    216            �           1259    26174    cus_mail    INDEX     >   CREATE INDEX cus_mail ON public.customer USING btree (email);
    DROP INDEX public.cus_mail;
       public            postgres    false    211            �           1259    26173    cus_name    INDEX     F   CREATE INDEX cus_name ON public.customer USING btree (customer_name);
    DROP INDEX public.cus_name;
       public            postgres    false    211            �           1259    26196 !   fki_tables_nhan_vien_phuc_vu_fkey    INDEX     a   CREATE INDEX fki_tables_nhan_vien_phuc_vu_fkey ON public.tables USING btree (nhan_vien_phuc_vu);
 5   DROP INDEX public.fki_tables_nhan_vien_phuc_vu_fkey;
       public            postgres    false    216            �           1259    26175 #   index_order_and_payment_customer_id    INDEX     h   CREATE INDEX index_order_and_payment_customer_id ON public.order_and_payment USING btree (customer_id);
 7   DROP INDEX public.index_order_and_payment_customer_id;
       public            postgres    false    214            1           2618    26116    payment _RETURN    RULE     �  CREATE OR REPLACE VIEW public.payment AS
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
       public          postgres    false    214    3218    214    213    213    213    214    214    214    215            �           2620    26171    order_and_payment auto_price    TRIGGER     v   CREATE TRIGGER auto_price AFTER INSERT ON public.order_and_payment FOR EACH ROW EXECUTE FUNCTION public.auto_price();
 5   DROP TRIGGER auto_price ON public.order_and_payment;
       public          postgres    false    214    224            �           2620    26132    set_table check_booking    TRIGGER     u   CREATE TRIGGER check_booking BEFORE INSERT ON public.set_table FOR EACH ROW EXECUTE FUNCTION public.check_booking();
 0   DROP TRIGGER check_booking ON public.set_table;
       public          postgres    false    209    221            �           2620    26172     order_and_payment doanh_thu_ngay    TRIGGER     ~   CREATE TRIGGER doanh_thu_ngay AFTER INSERT ON public.order_and_payment FOR EACH ROW EXECUTE FUNCTION public.doanh_thu_ngay();
 9   DROP TRIGGER doanh_thu_ngay ON public.order_and_payment;
       public          postgres    false    214    225            �           2606    26186     nhanvien nhanvien_chucvu_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.nhanvien
    ADD CONSTRAINT nhanvien_chucvu_id_fkey FOREIGN KEY (chucvu_id) REFERENCES public.chucvu(chucvu_id);
 J   ALTER TABLE ONLY public.nhanvien DROP CONSTRAINT nhanvien_chucvu_id_fkey;
       public          postgres    false    218    217    3223            �           2606    26133 4   order_and_payment order_and_payment_customer_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_and_payment
    ADD CONSTRAINT order_and_payment_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id);
 ^   ALTER TABLE ONLY public.order_and_payment DROP CONSTRAINT order_and_payment_customer_id_fkey;
       public          postgres    false    214    211    3211            �           2606    26138 2   order_and_payment order_and_payment_date_time_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_and_payment
    ADD CONSTRAINT order_and_payment_date_time_fkey FOREIGN KEY (date_time) REFERENCES public.doanh_thu(date_time);
 \   ALTER TABLE ONLY public.order_and_payment DROP CONSTRAINT order_and_payment_date_time_fkey;
       public          postgres    false    214    212    3213            �           2606    26143 0   order_and_payment order_and_payment_meal_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_and_payment
    ADD CONSTRAINT order_and_payment_meal_id_fkey FOREIGN KEY (meal_id) REFERENCES public.menu(meal_id);
 Z   ALTER TABLE ONLY public.order_and_payment DROP CONSTRAINT order_and_payment_meal_id_fkey;
       public          postgres    false    3215    214    213            �           2606    26148 1   order_and_payment order_and_payment_table_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_and_payment
    ADD CONSTRAINT order_and_payment_table_id_fkey FOREIGN KEY (table_id) REFERENCES public.tables(table_id);
 [   ALTER TABLE ONLY public.order_and_payment DROP CONSTRAINT order_and_payment_table_id_fkey;
       public          postgres    false    216    214    3221            �           2606    26153 $   set_table set_table_customer_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.set_table
    ADD CONSTRAINT set_table_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id);
 N   ALTER TABLE ONLY public.set_table DROP CONSTRAINT set_table_customer_id_fkey;
       public          postgres    false    209    211    3211            �           2606    26158 !   set_table set_table_table_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.set_table
    ADD CONSTRAINT set_table_table_id_fkey FOREIGN KEY (table_id) REFERENCES public.tables(table_id);
 K   ALTER TABLE ONLY public.set_table DROP CONSTRAINT set_table_table_id_fkey;
       public          postgres    false    209    216    3221            �           2606    26191 $   tables tables_nhan_vien_phuc_vu_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tables
    ADD CONSTRAINT tables_nhan_vien_phuc_vu_fkey FOREIGN KEY (nhan_vien_phuc_vu) REFERENCES public.nhanvien(nhanvien_id) NOT VALID;
 N   ALTER TABLE ONLY public.tables DROP CONSTRAINT tables_nhan_vien_phuc_vu_fkey;
       public          postgres    false    216    218    3225            8   j   x�=�]
� ���S�	"��0�XHA�*t���}���؃2����{$��fV}�
�v�`���T?��u��M�.K{��1��aT��F��Ǫ����
"� �.%"      3   8  x�}XK��8�\#O�T�w,�4�i}F�꧶g�6 �$QIHf�u���l�,s��Afe%ղY��� �w�$�Rx���}UU��j�B�����D^�zU�zo]Ť'��Io�OR�_��]ۚ�Һ�L���l�u5)W����^q'�w"<N%�<�w�������m�t�ʬ���t���Ż$Mx$=��T❻N�ϺQ�f�[V?�?Tk:�^�VI[e*x�$\�q�>ۼ��7�4S˺bY���-�}mG{����v�y���n�?�n��i��N��#�5�N�׽^r'�](p��������6%?7��XS/k��ڪ�{7]v���.��
�G"H�'����揓;���q6̭�F]�|�Hc�!���t�*�Ք�)��I���vj�|�����(�H�{>��v��j�Ul�� �N�U�3���op'���C�L74z揣�J$��K�^.�����N��Hb\6�^�x�nN�?8;���hɳ��zp���	����LCxh5����=��Y��E�o@,g�)҄g ��w��uk��r`O��ٓj��w��Nbʀ��������S��P�X����@��X��=�c��T�?�kd�z�8��8d�A���&}����ē�}p3���7Sq��%;旨�Z�����R���{����CH\n�G��hW�_�:�9�b�S��.\>�hw��B�73>W�)��~�us�x�A��&��;�?�%%���A�����g�Þ�<��Sv(%����0�[���[�;=��\�c�+�SWO�{3����Pi4rLT���H�S��y@�ۑ��W��w2�%�d?F�Ðȫ�n�_�mf�{Zڬ���)c�.��8�q�.��?}�Ǒ�h��A�q�V7gFw"ڥQ�^<�ݗ��kp�<��K��Y�maF����;!P)�|�EȖӥ�:SգnYy�D}v��pC!)9��D�FID?�H% E��=CG ���6�hlw{v�< ،d�l�>{������r9��K�@�$�#� a�~ ����C�Á:���K8d�ٌ�)6�!�]@��Ǟ�7��ÿ��Q��e��W+)��� �+(g{?帷i���Y]���)0���ao����DcŒK����=h��w{R�=��UO/�)���?���n�ӈckLt_������(�V-���;u�)B4dʓ#=���h�J�N-��؊˪�!( ����do �4Q�pl���k<gu��&}�~�~�ζ3��5�=�e}��f(n&�� &U��eB��Ci�� ��K(������/����P`#���247�]YZI��U��3�1�ݰ��w1�C� �I�/j�>)����`}I��?�⚬x��/}��	�^�Ш�Y;��?;4�dݰo�+&ҝ��lI @�����mFE�z�/���w76˿�b� . �q�zHӨ�[�bU�*��%�L�
ؗ��tN{`=�f�7Q��85u�6C^B!y�!��t��I�=�޸�GZ��9Y޾�"��8�[��$A^��4�aG����Se�U��)��$k-4�M�+�b���L�'brQ0~�k:�C��Խ�ma \8Dޒ �~ ���:�X5�(��B��~��ڡ�0d"B�@+'0ʴ�RfUi`�5y���zK`��Q,�!�ݿ��kBM:�0S\"Q�� uS��[�a�(�RA������hOgS�,7�X�����ivK���Q�4�ƣ��w賲Ҥ��P��~�=4����OSh�����d灕n��(��ps����lD�\E�����-|�9TL���H��r��� j��S��N8�05���arp6X�l�7�7�C�h�_������k����	���8����b)D�cf��8���������㲊�̞�`����v>\%L) ���)l��{u�K�jZ�W5���F�7d�}؛( +?)���aC�����V�댳�(\F
ԑl�PHԃ�9rˎ��viq]ٍ�F$�AD�MD4@�,�|�ьq�U�$�ł�z�嶂�Z� (bH���<�o��n4���l�p��%l6���4N�VX���0w�=�죚��{��gT�&��P��ШQo�AC)?z7�����fD}`]������h	�C��K�����8�]�b�5!#�_��#`n������6�.Ù1��~d�Ph��(�8� ����T��Uk �L����8��4�|i�J$�֏:��.F[kղ�|�KLW;qc�@t	ɓ�0�M�J�-ZZ�)�}��M���#f���4�͌�?�J�qf�j���SV���"�4LuJ>4	��ǣ����.����Wfؾj��dJ3=F8/e	ܠ�ur��k$�l�����$0���O f�&�h1wՐ
�	����5m�
]�,Ø�<Ld�n�o
�7ͽl(.���6�{yк���:��16Å�/�æ�J������2?�P��4\�9�q(_HE(��t���ƚ�I�us���>o�>�`�I�(���X$
֦�.�����:��OҌ�c���������^< �;�2Ȗ�[K"�MBW�"�@��0ap5Fٶ�Ry�/��������՗`GCFs�yf�Kr_A.��[�5�)�P�^o�i���<���G���,c�))�N�| �� ���V4�7�uh�iU�S�2�jHҾo^-�5)�R��ߧ�$z���S�2͊./�s	FWL5���|�|��5Ye�bY�Z��gN��\h f��s�rV�ő�g��`������h��+������4��Q-�,~1�-4�~����|�:�����e�����2�N?}#�S~E�E����ԍO��^"�3�)x�R�+��S��
��٣Oc��ΙZ4��<�����
`t���v���0h����:E�����,6\�du�QQU(�ofP.�e�5qgaO��[�"!���7��K<��!1�]SL-�4-�dE��|޸��4$���Qh��bQ�{�p�H>e�Ӱ�'(Hے[|��;!M��KBR�F�,~�O�d��U·@��-¼���'��H�4'C��;���b����
|��U�<�d�c��?�>Q	�ad�a��;Ͱ�M���X�+"2@��;Rǿi�a�?��Uv?�j/�G�����"fԪ,����g�� �Pڬ��E���័!�p'f����|f��ƲϺ\m�"�%�#^���E�Xu�ӠR�����{V=�[�`�-'E����'���k����e����oz"zsp�>����?G~�լ6z�p��'���_6.�ԉ<o6&���������{��{Zv����w����v�r�>�      4   .  x�]��m��ѵ�������$����A��r�D\�`�i�f~~ݟ����_?���|�Z��Wx���k�zy^ܒ߷���_���
��zxm^/���~��,nYܲ�eq���-�[�,nnnnnnnnnnn�(�,�b���Bl!�[�-�b���Bl!�[�-�b���Bl!�[�-�b���Bl!6F��`4F��`4F��`4F��`4F��`4F��`4F��`4�7�������د��
��zxm^/���~������-�[�,nYܲ�eq������������p˧� 6�b�� 6�b�� 6�b�� 6�b�� 6�b�� 6�b�� 6�b�Xp�!8���Cp�!8���Cp�!8���Cp�!��[�-�_N+bE���"VĊX+bE���"VĊX+bE���"VĊX+bE���"�`�`�`�`�`�`�`�`�`�`�`�`�`�`�`�`�`�`�`�`�`�`�`�`�`�`�`�`�`�|3���6b���Fl#�ۈm�6b���Fl#�ۈm�6b���Fl#�ۈm�6b���Fl#�{1z1z1z1z1z1z1z1z1z1z1z1z1z1z1z1z1z1z1z1z1z1z1z1z1z1z1z1z1z�}~U���A� v;��b���A� v;��b���A� v;��b���A� v;��.b���E�"v��]�.b���E�"v��]�.b���E�"v��]�.b���E�"v?�>�_�~�����_�~�����_�~�����_�~�����_�~�����_�~�����_�~�����_�~�����_�~�����_�~�����_�~�����_�~�����_�~�����_�~�����_�~�����_�~�����_�~�����_�~�����_�~�����_�~�����_�~�����_�~�����_�~����W�_�~����W�_�~����W�_�~����W�_�~����W�_�~����W�_�~����W�_�~����W�_�~����W�_�~����W�_�~����W�_�~����W�_�~����W�_�~����W�_�~����W�_�~���z}�T�JP	*A%���T�JP	*A%���T�JP	*A%���T�JP	*��n����X+bE���"VĊ�G���:_������������O������8L�a2�q���d&�0��8L�a2�q���d&�0��8L�a2�q���d&�0��8L�a2�q���d&�0��8L�a2�q���d&�0��8L�a2�q���d&�0��Xx	�%�� ^x	�%�� ^x	�%�� ^x	�%�� ^x	�%�� ^x	�%�� ^x	�%�� ^x	�%�� ^x	�%�� ^x	�%�� ^x	�%�� ^x	�%�� ^x	�%�� ^x	�%�� ^x	�%�� ^x	�%�� ^x	�%�� ^x	�%�� ^x	�%�� ^x	�%�� ^x	�%�� ^x	�%�� ^x	�%�� ^x	�%�� ^x	�%�� ^x	�%�� ^x	�%��w ���?~�\��X      5   �  x�mR�n�0�O_q_P��-�k:�S��c�L�)��|D���.Q� H#A�QC���I)Rj� $�w��G`QI\(�Q�n#�;�r�T(y%���@����q��C�PO�<)�%9Ё��έRmE����s(x�:K%�HH5u���l�-�͉ 2���ݘ����i�$"�}���+�l�kǓ}��ɑY}-a�m	��W��g�L��3q�Ñ�p_�˻�����.��W�es�T�'��qSci�Sq��7�0������^7q��_��9wZ'�2o�f�0�l/�}�}�_�����0���Y������{/�y���>l���.^�m%�K�&��f��O֓�Y}��u{D�d�2]c�d�鈎:hau�zp܁�'n%b���5�b�ʰz���<*R&�H�=��)��W�P      9   3  x�E��n�0�ϛ�����?8�H�J *��K/X���+ۤj���&io����(�9�P����E���L�Re�@%��uF�7{h)��dZI�@3Ϡ��)��`�ɰ��4Z�
8%�a�x�[Ӡ�#ULSșPs@(�[K�tz,��`I	�&PwD���.ᔴ��T���?;�B�S���|o�5���+Z;%(��P�b�M�����6�0P���hH,��%�R�V�b���(^��<��#ְ1���5~���Ք���uGv�/w�SA5��ؐx>y����b��\�r3{w�-?0�o����)I�_d�x�      6   I   x�3�44�T0�4bNcNSN###]s]#sNsS �2#F�)�"SNN#dE���!�d�i	Q���� �3�      2   @   x�]ɱ� ��`�������ϑ�Z\u���n�����4�"`����6��+�U� ycA      7   *   x�3���2� �D��3a",@�%X������� -G
I     