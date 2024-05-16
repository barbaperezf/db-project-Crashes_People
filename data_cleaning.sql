/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */
-- Initial setup
/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */

-- Allowing idempotency through destructive refresh
DROP SCHEMA IF EXISTS cleaning CASCADE;
CREATE SCHEMA cleaning;

-- Creating a copy of the cleaning table changing some types and excluding the drivers_license_state, ems_run_no, ejection, drivers_license_class and pedpedal_location columns
DROP TABLE IF EXISTS cleaning.crashes_people;
CREATE TABLE cleaning.crashes_people (
    person_id text NOT NULL,
	person_type VARCHAR(20) NOT NULL,
	crash_record_id text NOT NULL,
	vehicle_id text,
	crash_date TIMESTAMP NOT NULL,
	seat_no VARCHAR(2),
	city text,
	state text,
	zipcode text,
	sex CHAR,
	age NUMERIC,
	safety_equipment text,
	airbag_deployed text,
	injury_classification text,
	hospital text,
	ems_agency text,
	driver_action text,
	driver_vision text,
	physical_condition text,
	pedpedal_action text,
	pedpedal_visibility text,
	pedpedal_location text,
	bac_result text,
	bac_result_value NUMERIC,
	cell_phone_use text
);

INSERT INTO cleaning.crashes_people
SELECT TRIM(UPPER(person_id)),
       TRIM(UPPER(person_type)),
       crash_record_id,
       vehicle_id,
       crash_date,
       seat_no,
       TRIM(UPPER(city)),
       TRIM(UPPER(state)),
       TRIM(UPPER(zipcode)),
       TRIM(sex),
       age,
       TRIM(UPPER(drivers_license_class)),
       TRIM(UPPER(safety_equipment)),
       TRIM(UPPER(airbag_deployed)),
       TRIM(UPPER(injury_classification)),
       TRIM(UPPER(hospital)),
       TRIM(UPPER(ems_agency)),
       TRIM(UPPER(driver_action)),
       TRIM(UPPER(driver_vision)),
       TRIM(UPPER(physical_condition)),
       TRIM(UPPER(pedpedal_action)),
       TRIM(UPPER(pedpedal_visibility)),
       TRIM(UPPER(pedpedal_location)),
       TRIM(UPPER(bac_result)),
       bac_result_value,
       TRIM(UPPER(cell_phone_use))
FROM raw.crashes_people;

/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */
-- Cleaning city
/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */

UPDATE cleaning.crashes_people
SET city =
	CASE
		WHEN city ILIKE 'UNK%' OR city ILIKE 'UN' OR city ILIKE 'UN,' OR (city ILIKE 'UK%' AND city NOT ILIKE 'UKI%') OR (city ILIKE'UN%K%' AND city NOT ILIKE '%V%' AND city NOT ILIKE 'UNIERSITY PARK') OR city ILIKE '%U%K%N%W%' OR (city ILIKE '%U%N%N%W%' AND city NOT ILIKE '%WOO%' AND city NOT ILIKE 'FOUNTAINTOWN' AND city NOT ILIKE 'HUENNBERG/SWITZERLAND' AND city NOT ILIKE 'MOUNTAIN VIEW' ) OR city IS NULL THEN 'UNKNOWN'
		WHEN city ILIKE '%CHIC%' OR city ILIKE '%C%AGO%' OR city ILIKE '%CHGO%' OR city ILIKE '%CGHO%' OR city ILIKE 'CHG%' OR city ILIKE 'CHFO' OR city ILIKE 'CHCAG0' OR city ILIKE 'CHCIAG0' THEN 'CHICAGO'
		WHEN city ILIKE '%C%G%O' AND city NOT ILIKE '%ONTARIO%' AND city NOT ILIKE '%GORDO%' AND city NOT ILIKE '%HIDALGO%' AND city NOT ILIKE '%CHITTENANGO%' THEN 'CHICAGO'
		WHEN city ILIKE 'CHI%' AND city NOT ILIKE 'CHIL%' AND city NOT ILIKE 'CHIN%' AND city NOT ILIKE 'CHIP%'AND city NOT ILIKE 'CHIT%' THEN 'CHICAGO'
		WHEN city ILIKE '%ALGON%' OR city ILIKE 'ALONQUIN' OR city ILIKE 'ALGUQUIN' THEN 'ALGONQUIN'		
		WHEN city ILIKE 'ADD%' OR city ILIKE 'ADI%' THEN 'ADDISON'		
		WHEN city ILIKE '%LINC%' THEN 'LINCOLNWOOD'	
		WHEN city ILIKE '%ARLI%' THEN 'ARLINGTON'	
		WHEN city ILIKE '%HAZEL%' THEN 'HAZEL CREST'	
		WHEN city ILIKE '%BOL%' OR city ILIKE '%BOI%' THEN 'BOLINGBROOK'	
		WHEN city ILIKE '%DES%P%' THEN 'DES PLAINES'	
		WHEN city ILIKE '%ELK GROVE%' THEN 'ELK GROVE VILLAGE'	
		WHEN city ILIKE '%ELMWOOD%' OR city ILIKE 'ELMWO0D' THEN 'ELMWOOD PARK'	
		WHEN city ILIKE '%EVERGREEN%' THEN 'EVERGREEN PARK'	
		WHEN city ILIKE '%FRANKLIN%' THEN 'FRANKLIN PARK'	
		WHEN city ILIKE '%FRANKLIN%' THEN 'FRANKLIN PARK'	
		WHEN city ILIKE '%HIGHLAND%' THEN 'HIGHLAND HEIGHTS'	
		WHEN city ILIKE '%GARY%' OR city ILIKE '%CARY%' THEN 'GARY'	
		WHEN city ILIKE '%HARDWOOD%' OR city ILIKE '%HARWOOD%' THEN 'HARWOOD HEIGHTS'	
		WHEN city ILIKE '%GRANGE%' OR city ILIKE '%GRANGA%' THEN 'LA GRANGE'	
		WHEN city ILIKE '%MARENGO%' THEN 'MANTENO'	
		WHEN city ILIKE '%MERR%' THEN 'MERRILLVILLE'	
		WHEN city ILIKE '%M%PROSPECT%' OR city ILIKE 'MOUNT PEOSPECT' OR city ILIKE 'MOUNT POR%' OR city ILIKE 'MOUNT POS%' OR city ILIKE 'MOUNT PR%' OR city ILIKE 'MT PR%'OR city ILIKE 'MT PPR%' THEN 'MOUNT PROSPECT'	
		WHEN city ILIKE '%ROUND LAKE%' THEN 'ROUND LAKE'	
		WHEN city ILIKE '%S%T%JOHN%' THEN 'SAINT JOHN'	
		WHEN city ILIKE '%SUMMIT%' THEN 'SUMMIT'	
		WHEN city ILIKE '%WOODDALE%' THEN 'WOOD DALE'	
		WHEN city ILIKE '%PALOS%' THEN 'PALOS'	
		WHEN city ILIKE 'ALS%' THEN 'ALSIP'	
		WHEN city ILIKE 'ANN %' THEN 'ANN ARBOR'	
		WHEN city ILIKE 'ANTIO%' THEN 'ANTIOCH'	
		WHEN city ILIKE 'ALRIN%' OR (city ILIKE 'ARL%' AND city NOT ILIKE '%TA') OR city ILIKE 'ARTHI%' THEN 'ARLINGTON'	
		WHEN city ILIKE '%ATLANDA%' THEN 'ATLANTA'	
		WHEN city ILIKE 'AURO%' THEN 'AURORA'	
		WHEN city ILIKE '%BARRIN%' OR city ILIKE 'BARRIG%' THEN 'BARRINGTON'	
		WHEN city ILIKE '%BARTLETT%' THEN 'BARTLETT'	
		WHEN city ILIKE '%BATAVI%' THEN 'BATAVIA'	
		WHEN city ILIKE '%BARTLETT%' THEN 'BARTLETT'	
		WHEN city ILIKE '%BEACH P%' OR city ILIKE '%BEACHP%' OR city ILIKE 'BEACK%' THEN 'BEACH PARK'	
		WHEN city ILIKE '%BEDFORD%' THEN 'BEDFORD PARK'	
		WHEN city ILIKE '%BEECHER%' THEN 'BEECHER'	
		WHEN city ILIKE '%BELLEV%' THEN 'BELLEVUE'	
		WHEN city ILIKE '%BELLWO%' OR city ILIKE '%BELLWE%' OR city ILIKE '%BELLWI%' OR city ILIKE '%BELLWQ%' OR city ILIKE '%BELLWW%' OR city ILIKE 'BELW%'  THEN 'BELLWOOD'	
		WHEN city ILIKE '%BELOUT%' THEN 'BELOIT'	
		WHEN city ILIKE '%BELVIDE%' OR city ILIKE '%BELVED%' THEN 'BELVIDERE'	
		WHEN city ILIKE 'BEN%EN%' THEN 'BENSENVILLE'	
		WHEN city ILIKE '%BRIDGEV%' OR city ILIKE '%BRIDGEV%' OR (city ILIKE 'BRIDGE%' AND city ILIKE 'IEW%') THEN 'BRIDGEVIEW'	
		WHEN city ILIKE '%BROADV%' OR city ILIKE 'BROAEDVIEW' THEN 'BROADVIEW'	
		WHEN city ILIKE '%BROOK%F%' THEN 'BROOKFIELD'	
		WHEN city ILIKE 'BERK%' THEN 'BERKELEY'	
		WHEN city ILIKE 'BERW%' OR city ILIKE 'BERY%' THEN 'BERWYN'	
		WHEN city ILIKE '%BLOOMI%' AND city NOT ILIKE '%T%' AND city NOT ILIKE '%R%' OR city ILIKE '%BLOOM%G%DALE%' THEN 'BLOOMINGDALE'	
		WHEN city ILIKE 'BLUE I%' OR city ILIKE 'BULE I%' THEN 'BLUE ISLAND'	
		WHEN city ILIKE 'BOUR%' OR city ILIKE 'BURBO%' THEN 'BOURBONNAIS'	
		WHEN city ILIKE 'BRADL%' THEN 'BRADLEY'	
		WHEN city ILIKE '%BROOKLI%' OR city ILIKE'%BROOKLY%' OR city ILIKE'%BROOKYN%' THEN 'BROOKLYN'	
		WHEN city ILIKE 'BUFF%' OR city ILIKE 'BUGGALO%' OR city ILIKE 'BULLALO%' THEN 'BUFFALO GROVE'	
		WHEN city ILIKE 'BURB%' AND city NOT ILIKE 'BURBO%' THEN 'BURBANK'	
		WHEN city ILIKE 'BURLIN%' AND city ILIKE 'BURLON%' THEN 'BURLINGTON'	
		WHEN city ILIKE '%BURNHA%' THEN 'BURNHAM'	
		WHEN city ILIKE 'BURR%' THEN 'BURR RIDGE'	
		WHEN city ILIKE 'CALL%' OR city ILIKE 'CALM%' OR city ILIKE 'CALU%' THEN 'CALUMET'	
		WHEN city ILIKE '%CARBON%' THEN 'CARBONDALE'	
		WHEN city ILIKE '%CARME%' THEN 'CARMEL'	
		WHEN city ILIKE '%CAROL%' THEN 'CAROL STREAM'	
		WHEN city ILIKE 'CARP%' THEN 'CARPENTERSVILLE'	
		WHEN city ILIKE '%CEDAR%' OR city ILIKE '%CEDER%' OR city ILIKE '%CEDDAR%' THEN 'CEDAR'	
		WHEN city ILIKE 'CHAMP%' OR city ILIKE 'CHANP%' THEN 'CHAMPAIGN'	
		WHEN city ILIKE 'CHANN%' AND city NOT ILIKE 'CHANNEL%' THEN 'CHANNAHON'	
		WHEN city ILIKE 'CHARLES%' THEN 'CHARLESTON'	
		WHEN city ILIKE '%CHESTERO%' OR city ILIKE '%CHESTERS%' THEN 'CHESTERTON'	
		WHEN city ILIKE '%CCICERO%' OR city ILIKE '%CCERO%' OR (city ILIKE 'CIC%' AND city NOT ILIKE'CICC%') OR city ILIKE '%CIDERO%' OR city ILIKE 'CIE%' OR city ILIKE 'CIIC%' THEN 'CICERO'	
		WHEN city ILIKE '%C%I%N%C%A%' OR city ILIKE 'CINCINNTI' OR city ILIKE 'CINN' THEN 'CINCINATTI'	
		WHEN city ILIKE '%CLARENDON%' THEN 'CLARENDON HILLS'	
		WHEN city ILIKE 'CLEV%' THEN 'CLEVELAND'	
		WHEN city ILIKE '%CLINTON%' THEN 'CLINTON'	
		WHEN city ILIKE 'COLUMBI%' OR city ILIKE 'COLUMBA%' THEN 'COLUMBIA'	
		WHEN city ILIKE '%COLUMBU%' THEN 'COLUMBUS'	
		WHEN city ILIKE 'COUNR%' OR city ILIKE 'COUNT%' THEN 'COUNTRY CLUB HILLS'	
		WHEN city ILIKE '%CREST%' OR city ILIKE '%CRETWOOD%' THEN 'CRESTWOOD'	
		WHEN city ILIKE 'CRET%' THEN 'CRETE'	
		WHEN city ILIKE 'CROWN%' THEN 'CROWN POINT'	
		WHEN city ILIKE 'CRYS%' THEN 'CRYSTAL LAKE'	
		WHEN city ILIKE 'DALL%' THEN 'DALLAS'	
		WHEN city ILIKE '%DANVILL%' OR city ILIKE 'DANN%' OR city ILIKE 'DANS%' OR city ILIKE 'DANVELLE' THEN 'DANVILLE'	
		WHEN city ILIKE 'DARE%' OR (city ILIKE 'DARI%' AND city NOT ILIKE '%ON') THEN 'DARIEN'	
		WHEN city ILIKE 'DAVE%' THEN 'DAVENPORT'	
		WHEN city ILIKE 'DECAT%' OR city ILIKE 'DECT%' THEN 'DECATUR'	
		WHEN city ILIKE '%DEERF%' THEN 'DEERFIELD'	
		WHEN city ILIKE 'DEK%' THEN 'DEKALB'	
		WHEN city ILIKE '%DENVER%' OR city ILIKE 'DEMVER' THEN 'DENVER'	
		WHEN city ILIKE '%DES MOI%' OR city ILIKE 'DES MON%' THEN 'DES MOINES'	
		WHEN city ILIKE '%DES PLAINES%' OR city ILIKE 'DES [LAINES' THEN 'DES PLAINES'	
		WHEN city ILIKE 'DETR%' THEN 'DETROIT'	
		WHEN city ILIKE '%DIX%O' THEN 'DIXMOOR'	
		WHEN city ILIKE 'DOL%' THEN 'DOLTON'	
		WHEN city ILIKE 'DOWNER%' OR city ILIKE 'DOWE%' OR city ILIKE 'DOWNS%' OR city ILIKE 'DPWNERS GROVE' OR city ILIKE 'DROW%' OR city ILIKE 'DOWNDERS' THEN 'DOWNERS GROVE'	
		WHEN city ILIKE 'DUBU%' OR city ILIKE 'DUBQ%' THEN 'DUBUQUE'	
		WHEN city ILIKE '%DYER%' THEN 'DYER'	
		WHEN city ILIKE '%EAST MOL%' THEN 'EAST MOLINE'	
		WHEN city ILIKE 'ELK G%' OR city ILIKE 'ELK  G%' OR city ILIKE 'ELKG%' THEN 'ELK GROVE VILLAGE'	
		WHEN city ILIKE '%ELMH%' OR city ILIKE 'ELNH%' THEN 'ELMHURST'	
		WHEN city ILIKE '%ELMWOOD%' OR city ILIKE 'ELNWO%' OR city ILIKE 'ELW%' THEN 'ELMWOOD PARK'	
		WHEN city ILIKE '%ELPASO%' THEN 'EL PASO'	
		WHEN city ILIKE 'EVEANS%' OR city ILIKE 'EVENT%' OR city ILIKE 'EVA%' OR city ILIKE 'EVNASTON' OR city ILIKE 'EVNSTON' THEN 'EVANSTON'	
		WHEN city ILIKE '%EVER%GREEN%' OR city ILIKE '%EVENGREEN%' OR city ILIKE 'EVER%' OR city ILIKE 'EVR%' THEN 'EVERGREEN PARK'	
		WHEN city ILIKE 'FLOOR%' OR city ILIKE 'FLOS%' OR city ILIKE 'FLOUSSMORE' THEN 'FLOSSMOOR'	
		WHEN city ILIKE 'FORD%' THEN 'FORD HEIGHTS'	
		WHEN (city ILIKE 'FORE%' AND city NOT ILIKE '%VIEW' AND city NOT ILIKE '%LLE%') OR city ILIKE 'FORREST%' OR city ILIKE 'FORSE%' THEN 'FOREST PARK'	
		WHEN city ILIKE 'FORT%W%Y%' THEN 'FORT WAYNE'	
		WHEN city ILIKE '%FRANKF%' THEN 'FRANKFORT'	
		WHEN city ILIKE '%FRANKL%' OR city ILIKE 'FRANKI%' OR city ILIKE 'FRANLIN PARK' THEN 'FRANKLIN PARK'	
		WHEN city ILIKE '%GENEV%' OR city ILIKE '%GENV%' THEN 'GENEVA'	
		WHEN city ILIKE '%GILBER%' THEN 'GILBERTS'	
		WHEN city ILIKE '%GLEN E%' THEN 'GLEN ELLYN'	
		WHEN city ILIKE '%GLENCO%' THEN 'GLENCOE'	
		WHEN city ILIKE '%GLENDA%' OR city ILIKE '%GLENDELE%' OR city ILIKE 'GLENDIVE' OR city ILIKE 'GLENDL%' OR city ILIKE 'GLENG%' OR city ILIKE '%GLENHEIGHT%' OR city ILIKE '%GLENN%HEI%' THEN 'GLENDALE HEIGHTS'	
		WHEN city ILIKE 'GLENV%' OR city ILIKE 'GLENNV%' THEN 'GLENVIEW'	
		WHEN city ILIKE '%GLENWO%' THEN 'GLENWOOD'	
		WHEN city ILIKE '%GRAND RA%' THEN 'GRAND RAPIDS'	
		WHEN city ILIKE '%GRAYS%LAKE%' THEN 'GRAYSLAKE'	
		WHEN city ILIKE 'GRIF%' OR city ILIKE 'GRIGGITH' OR city ILIKE 'GRIIFFITH' THEN 'GRIFFITH'	
		WHEN city ILIKE 'HAMM%' OR city ILIKE 'HAMO%' THEN 'HAMMOND'	
		WHEN city ILIKE 'HAMPHIRE' OR city ILIKE 'HAMPSIRE' THEN 'HAMPSHIRE'	
		WHEN (city ILIKE '%H%A%N%O%E%R%' AND city NOT ILIKE '%NORTH' AND city NOT ILIKE '%HOME%') OR city ILIKE 'HANOVR%' OR city ILIKE 'HAOVER%' THEN 'HANOVER PARK'	
		WHEN city ILIKE 'HARVE%' OR city ILIKE 'HARVY' THEN 'HARVEY'	
		WHEN city ILIKE 'HARWO%' OR city ILIKE 'HARWE%' OR city ILIKE 'HARWW%' THEN 'HARWOOD HEIGHTS'	
		WHEN city ILIKE '%HAWTHORN%' THEN 'HAWTHORN WOODS'	
		WHEN city ILIKE 'HIC%' THEN 'HICKORY HILLS'	
		WHEN city ILIKE '%HILLSID%' OR city ILIKE 'HILLSD%' THEN 'HILLSIDE'	
		WHEN city ILIKE 'HOBAR%' OR city ILIKE 'HOART' OR city ILIKE 'HOBERT' THEN 'HOBART'	
		WHEN city ILIKE 'HOF%' THEN 'HOFFMAN ESTATES'	
		WHEN city ILIKE '%HOMER%GLE%' OR city ILIKE 'HOMER' OR city ILIKE '%HOMER CLE%' OR city ILIKE 'HOMER GLYNN' THEN 'HOMER GLEN'	
		WHEN city ILIKE '%HOMEW%' OR city ILIKE 'HOMWEWOOD' THEN 'HOMEWOOD'	
		WHEN city ILIKE 'HOUST%' OR city ILIKE 'HOUTS%' THEN 'HOUSTON'	
		WHEN city ILIKE '%INDIA%P%K%' OR city ILIKE 'INDIAN HEAD' THEN 'INDIAN HEAD PARK'	
		WHEN (city ILIKE 'INDIAN%' AND city NOT ILIKE 'INDIAN %' AND city NOT ILIKE 'INDIANA' AND city NOT ILIKE'%INDIA%P%K%' AND city NOT ILIKE 'INDIAN HEAD') OR city ILIKE 'INDIIANAPOLIS' OR city ILIKE  'INDIAPOLIS' THEN 'INDIANAPOLIS'	
		WHEN city ILIKE 'IOWA%' THEN 'IOWA CITY'	
		WHEN city ILIKE 'ISLAND%' THEN 'ISLAND LAKE'	
		WHEN city ILIKE 'ITAC%' OR city ILIKE 'ITAQ%' OR city ILIKE 'ITASA' OR city ILIKE '%ITASCA%' OR city ILIKE '%ITASKA%' OR city ILIKE 'ITHA%' OR city ILIKE 'ITSCA' THEN 'ITASCA'	
		WHEN city ILIKE 'JACKSON %' THEN 'JACKSON'	
		WHEN city ILIKE 'JACKONVILLE' OR city ILIKE 'JACKSONB%' OR city ILIKE 'JACKSONS%' OR city ILIKE 'JACKSONV%' OR city ILIKE 'JACKSVILLE' THEN 'JACKSONVILLE'	
		WHEN city ILIKE 'JANES%' OR city ILIKE 'JANSEVILLE' THEN 'JANESVILLE'	
		WHEN city ILIKE 'JOI%' OR city ILIKE 'JOL%' THEN 'JOLIET'	
		WHEN city ILIKE 'JUS%' THEN 'JUSTICE'	
		WHEN city ILIKE 'KALAM%' OR city ILIKE 'KAKAMAZOO' THEN 'KALAMAZOO'	
		WHEN city ILIKE 'KANK%' OR city ILIKE 'KANAKEE' THEN 'KANKAKEE'	
		WHEN city ILIKE 'KANSA%' OR city ILIKE 'KANAS%CITY' THEN 'KANSAS CITY'	
		WHEN city ILIKE 'KENOS%' THEN 'KENOSHA'	
		WHEN city ILIKE 'KISS%' THEN 'KISSIMMEE'	
		WHEN city ILIKE 'LAF%' OR city ILIKE '%LFAYETTE%' OR city ILIKE '%LAFAYETTE%' OR city ILIKE 'WEST LAF%' OR city ILIKE 'WEST LAR%' OR city ILIKE 'WEST LAY%' THEN 'LAFAYETTE'	
		WHEN city ILIKE 'LAKE BUFF' THEN 'LAKE BLUFF'	
		WHEN city ILIKE 'LAKE F%' THEN 'LAKE FOREST'	
		WHEN city ILIKE 'LAKE IN %' OR city ILIKE 'LAKEIN THE HILL' THEN 'LAKE IN THE HILLS'	
		WHEN city ILIKE 'LAKE STA%' THEN 'LAKE STATION'	
		WHEN city ILIKE 'LAKE VILL%' THEN 'LAKE VILLA'	
		WHEN city ILIKE 'LAKE Z%' THEN 'LAKE ZURICH'	
		WHEN city ILIKE 'LANI%' OR city ILIKE 'LANN%' OR city ILIKE 'LANS%' THEN 'LANSING'	
		WHEN city ILIKE '%LAS VEGAS%' OR city ILIKE 'LAS V%' OR city ILIKE 'LAST VEGAS' OR city ILIKE '%LASVEGAS%' THEN 'LAS VEGAS'	
		WHEN city ILIKE 'LEM%' OR city ILIKE 'LEOMONT' THEN 'LEMONT'	
		WHEN city ILIKE 'LEX%' THEN 'LEXINGTON'	
		WHEN city ILIKE 'LIBERT%' OR city ILIKE 'LIBETYVILLE' THEN 'LIBERTYVILLE'	
		WHEN city ILIKE 'LINDE%' OR city ILIKE 'LINDH%' THEN 'LINDENHURST'	
		WHEN city ILIKE 'LISI%' OR city ILIKE 'LISL%' THEN 'LISLE'	
		WHEN city ILIKE 'LOCK%' OR city ILIKE 'LOCPORT' OR city ILIKE 'LOCLPORT' THEN 'LOCKPORT'	
		WHEN city ILIKE 'LOMAB%' OR city ILIKE 'LOMAR%' OR city ILIKE 'LOMDARD' OR city ILIKE 'LOMB%' THEN 'LOMBARD'	
		WHEN city ILIKE '%LOS%ANGELES%' OR city ILIKE 'LOS AN%%' THEN 'LOS ANGELES'	
		WHEN city ILIKE 'LOUI%' OR city ILIKE 'LOUDONVILLE' OR city ILIKE 'LOUSIVILLE' THEN 'LOUISVILLE'	
		WHEN city ILIKE 'LOWE%' AND city NOT ILIKE 'LOWER%' THEN 'LOWELL'	
		WHEN city ILIKE 'LYNNWOOD' OR city ILIKE 'LYNSW%' OR city ILIKE 'LYNW%' OR city ILIKE 'LYWOOD' THEN 'LYNWOOD'	
		WHEN city ILIKE 'LYON%' THEN 'LYONS'	
		WHEN city ILIKE 'MACOM%' OR city ILIKE 'MACN%' OR city ILIKE 'MACON' THEN 'MACOMB'	
		WHEN city ILIKE 'MADD%' OR city ILIKE 'MADI%' THEN 'MADISON'	
		WHEN city ILIKE 'MANHAT%' OR city ILIKE 'MANHHATTEN' THEN 'MANHATTAN'	
		WHEN city ILIKE 'MANTEL%' OR city ILIKE 'MANTEN%' THEN 'MANTENO'	
		WHEN city ILIKE 'MARKEM' OR city ILIKE 'MARKJAM' OR city ILIKE 'MARKH%' THEN 'MARKHAM'	
		WHEN city ILIKE 'MATTE%' OR city ILIKE 'MATTS%' OR city ILIKE 'MATTO%' OR city ILIKE 'MATSON' OR city ILIKE 'MATRTESON' OR city ILIKE 'MATTTESON' THEN 'MATTESON'	
		WHEN city ILIKE 'MAYW%' THEN 'MAYWOOD'	
		WHEN city ILIKE 'MCH%' THEN 'MCHENRY'	
		WHEN city ILIKE '%MELROSE%' OR city ILIKE 'MELO%' OR city ILIKE 'MERLOSE' THEN 'MELROSE PARK'	
		WHEN city ILIKE 'MEM%' THEN 'MEMPHIS'	
		WHEN city ILIKE '%MIAMI%' OR (city ILIKE 'MIA%' AND city NOT ILIKE 'MIAMISBURG') THEN 'MIAMI'	
		WHEN city ILIKE 'MICH%' AND city NOT ILIKE 'MICHAWAKA' AND city NOT ILIKE 'MICHIANA%' THEN 'MICHIGAN CITY'	
		WHEN city ILIKE 'MIDLI%' OR city ILIKE 'MIDLO%' OR city ILIKE 'MIDMIDLOTHIAN' OR city ILIKE 'MIDELOTHIAN' OR city ILIKE 'MIDHLOTIAN' OR city ILIKE 'MIDO%' OR city ILIKE 'MIDTHLOTHIAN' OR city ILIKE 'MIIDLOTHIAN' THEN 'MIDLOTHIAN'	
		WHEN city ILIKE 'MILWA%' THEN 'MILWAUKEE'	
		WHEN city ILIKE 'MINAEAPOLIS' OR city ILIKE 'MINNA%' OR city ILIKE 'MINNEA%' OR city ILIKE 'MINNEP%' OR city ILIKE 'MINNI%' OR city ILIKE 'MINNW' THEN 'MINNEAPOLIS'	
		WHEN city ILIKE '%MINOOKA%' OR city ILIKE 'MINONK' OR city ILIKE 'MINOCQUA' THEN 'MINOOKA'	
		WHEN city ILIKE 'MOKE%' OR city ILIKE 'MOEKNA' OR city ILIKE 'MOLENA' OR city ILIKE 'MOLINE' OR city ILIKE 'MONEKA' THEN 'MOKENA'
		WHEN city ILIKE 'MONTG%' OR city ILIKE 'MONTOGOMERY' OR city ILIKE 'MONTOM%' THEN 'MONTGOMERY'	
		WHEN city ILIKE 'MORRIS %' OR city ILIKE 'MORIS' OR city ILIKE 'MORRI' THEN 'MORRIS'	
		WHEN city ILIKE 'MORTON%' OR city ILIKE 'MORTI%' OR city ILIKE 'MORTOM%' OR city ILIKE 'MORTOPN' THEN 'MORTON GROVE'	
		WHEN city ILIKE 'MUNDA%' OR city ILIKE 'MUNDE%' OR city ILIKE 'MUNDL%' THEN 'MUNDELEIN'	
		WHEN city ILIKE 'MUNS%' THEN 'MUNSTER'	
		WHEN city ILIKE '%NAPE%' OR city ILIKE 'NAOERVILLE' OR city ILIKE 'NAPLEVILLE' OR city ILIKE 'NAPP%' OR city ILIKE 'NAPREVILLE' THEN 'NAPERVILLE'	
		WHEN city ILIKE 'NASHV%' OR city ILIKE 'NASHIVELLE' THEN 'NASHVILLE'	
		WHEN city ILIKE 'NEW LEN%' OR city ILIKE 'NEW LONOX' OR city ILIKE 'NEW LWNOX' THEN 'NEW LENOX'	
		WHEN city ILIKE 'NEW Y%' OR city ILIKE '%NEWYORK%' THEN 'NEW YORK'	
		WHEN city ILIKE 'NIL%' THEN 'NILES'	
		WHEN city ILIKE 'NORMAL%' OR city ILIKE 'NORMAN' THEN 'NORMAL'	
		WHEN city ILIKE 'NORR%G%' THEN 'NORRIDGE'	
		WHEN city ILIKE 'NORTH%AUR%' THEN 'NORTH AURORA'	
		WHEN city ILIKE '%NORTH%RIVERSIDE%' OR city ILIKE 'RIVESIDE' OR city ILIKE '%RIVERSIDE%' OR (city ILIKE '%RIVER%S%' AND city NOT ILIKE 'B%' AND city NOT ILIKE '%F%' AND city NOT ILIKE '%HI%' AND city NOT ILIKE '%W%' AND city NOT ILIKE '%G%' AND city NOT ILIKE 'THR%') THEN 'RIVERSIDE'	
		WHEN city ILIKE 'NORTHB%' THEN 'NORTHBROOK'	
		WHEN city ILIKE 'NORTHF%' THEN 'NORTHFIELD'	
		WHEN city ILIKE 'NORTHL%' THEN 'NORTHLAKE'	
		WHEN city ILIKE 'OAK BR%' OR city ILIKE 'OAKBR%' OR city ILIKE '%OAKBROOK%' THEN 'OAK BROOK'	
		WHEN city ILIKE '%OAK F%' OR city ILIKE 'OAKF'  OR city ILIKE 'OAL F' OR city ILIKE 'OAW F' OR city ILIKE 'OA%FOR%' THEN 'OAK FOREST'	
		WHEN city ILIKE '%OAK L%' OR city ILIKE 'OAKL' OR city ILIKE 'OAL L' OR city ILIKE 'OAW L' OR city ILIKE 'OA%LAWN%' THEN 'OAKLAWN'	
		WHEN city ILIKE '%OAK P%' OR city ILIKE 'OAKP'  OR city ILIKE 'OAL P' OR city ILIKE 'OAW P' OR city ILIKE 'OA%PARK%' OR city ILIKE '0AK PARK' THEN 'OAK PARK'	
		WHEN city ILIKE 'OLYM%' OR city ILIKE 'OLYP%' OR city ILIKE 'OLUMPIA FIELDS' OR city ILIKE 'OLYLMPIA FIELDS' THEN 'OLYMPIA FIELDS'	
		WHEN city ILIKE 'ORLAND %' OR city ILIKE 'ORLANDHILLS' OR city ILIKE 'ORALND PARK' OR city ILIKE 'ORAND PARK' OR city ILIKE 'ORLA D PARK' OR city ILIKE 'ORLANDH%' OR city ILIKE 'ORLANDO%' OR city ILIKE 'ORLANDPARK' OR city ILIKE 'ORLEND PARK' OR city ILIKE 'ORLND PARK' THEN 'ORLAND PARK'	
		WHEN city ILIKE 'OMAHA%' THEN 'OMAHA'	
		WHEN city ILIKE 'OSW%' OR city ILIKE 'OSTEGO' OR city ILIKE 'OSSEO' THEN 'OSWEGO'	
		WHEN city ILIKE '%OTTAWA%' OR city ILIKE 'OTTOWA' OR city ILIKE 'OTTU' THEN 'OTTAWA'	
		WHEN city ILIKE 'PAL%' AND (city NOT ILIKE 'PALAS%' OR city NOT ILIKE 'PALI%') OR city ILIKE 'PALTINE' THEN 'PALATINE'	
		WHEN city ILIKE 'PARK C%' OR city ILIKE 'PARKC%' THEN 'PARK CITY'	
		WHEN city ILIKE 'PARK R%' OR city ILIKE 'PARK  R%' OR city ILIKE 'PARKR%' THEN 'PARK RIDGE'	
		WHEN city ILIKE 'PARK F%' OR city ILIKE 'PARK  F%' OR city ILIKE 'PARKF%' THEN 'PARK FOREST'	
		WHEN city ILIKE 'PEOR%' OR city ILIKE 'PEOPRIA' THEN 'PEORIA'	
		WHEN city ILIKE 'PHILA%' THEN 'PHILADELPHIA'	
		WHEN city ILIKE 'PHO%' AND city NOT ILIKE 'PHOPHETSTOWN' THEN 'PHOENIX'	
		WHEN city ILIKE 'PINGREE%' THEN 'PINGREE GROVE'	
		WHEN city ILIKE 'PITTS%' OR city ILIKE 'PITSBURG' OR city ILIKE 'PITTBURGH' OR city ILIKE 'PITTTSBURGH' THEN 'PITTSBURGH'	
		WHEN city ILIKE 'PLAI%' OR city ILIKE 'PL;AINFIELD' OR city ILIKE 'PLANE%' OR city ILIKE 'PLANF%' THEN 'PLAINFIELD'	
		WHEN city ILIKE 'PLANO%' THEN 'PLANO'	
		WHEN city ILIKE 'PORTAG%' THEN 'PORTAGE'	
		WHEN city ILIKE 'PROS%' OR city ILIKE 'PROP%' THEN 'PROSPECT HEIGHTS'	
		WHEN city ILIKE 'RICHMON%' AND city ILIKE 'RICHMOUND' OR city ILIKE 'RICHOND' OR city ILIKE 'RICHRON%' THEN 'RICHMOND'	
		WHEN city ILIKE 'RICHT%' OR city ILIKE 'RICHRON PARK' OR city ILIKE 'RICTON PARK' THEN 'RICHTON PARK'	
		WHEN city ILIKE 'RIVER F%' OR city ILIKE 'RIVER%FOREST' THEN 'RIVER FOREST'	
		WHEN city ILIKE 'RIVER G%' OR city ILIKE 'RIVER%GROVE' THEN 'RIVER GROVE'	
		WHEN city ILIKE 'RIVERD%' OR city ILIKE 'RIVERALE' OR city ILIKE 'RIVREDALE' THEN 'RIVERDALE'	
		WHEN city ILIKE 'RIVERWOO%' OR city ILIKE 'RIVEWOODS' THEN 'RIVERWOODS'	
		WHEN city ILIKE 'ROBB%' OR city ILIKE 'ROBINS' THEN 'ROBBINS'	
		WHEN city ILIKE 'ROCHEST%' THEN 'ROCHESTER'	
		WHEN city ILIKE 'ROCK %' THEN 'ROCK ISLAND'	
		WHEN city ILIKE 'ROCKF%' THEN 'ROCKFORD'	
		WHEN city ILIKE 'ROLLING%' OR city ILIKE 'ROLL%MEA%' OR city ILIKE 'ROLING MEADOWS' THEN 'ROLLING MEADOWS'	
		WHEN city ILIKE 'ROME%ILL%' OR city ILIKE 'ROMEOV%' OR city ILIKE 'ROMOVILLE' OR city ILIKE 'ROMROVILLE' THEN 'ROMEOVILLE'	
		WHEN city ILIKE 'ROSELL%' THEN 'ROSELLE'	
		WHEN city ILIKE 'ROSEMO%' THEN 'ROSEMONT'	
		WHEN city ILIKE 'ROUND %' THEN 'ROUND LAKE'	
		WHEN city ILIKE '%SAINT%CHARLES%' OR city ILIKE 'ST%CHARLES' OR city ILIKE 'SAIN CHARLES' OR city ILIKE 'SAINT CH%' OR city ILIKE 'SAINT CARLES' OR city ILIKE 'ST. CHARLES' THEN 'SAINT CHARLES'	
		WHEN city ILIKE 'SAN ANT%' THEN 'SAN ANTONIO'	
		WHEN city ILIKE 'SAN DIA%' OR city ILIKE 'BORRAR' THEN 'SAN DIEGO'	
		WHEN city ILIKE 'SAUK%' OR city ILIKE 'SAULK%' OR city ILIKE 'SAUL VILLAGE' OR city ILIKE 'SAULT%' THEN 'SAUK VILLAGE'	
		WHEN city ILIKE 'SCHAM%' OR city ILIKE 'SCHAN%' OR city ILIKE 'SCHAS%' THEN 'SCHAMBURG'	
		WHEN city ILIKE '%SHAU%' OR city ILIKE 'SCHAWNBURG' OR city ILIKE 'SCAUMBURG' OR city ILIKE 'SCHAM%' OR city ILIKE 'SCHAN%' OR city ILIKE 'SCHAS%' OR city ILIKE 'SCHHAUMBURG' THEN 'SCHAUMBURG'	
		WHEN city ILIKE 'SCHE%' THEN 'SCHERERVILLE'	
		WHEN city ILIKE 'SCHI%' OR city ILIKE 'SCHL%' THEN 'SCHILLER PARK'	
		WHEN city ILIKE 'SEAT%' THEN 'SEATTLE'	
		WHEN city ILIKE 'SHOREW%' OR city ILIKE 'SHORE W%' OR city ILIKE 'SHOREVIEW' OR city ILIKE 'SHOOREWOOD' OR city ILIKE 'SHREWOOD' THEN 'SHOREWOOD'	
		WHEN city ILIKE 'SKO%' OR city ILIKE 'SKK%' OR city ILIKE 'SKI%' THEN 'SKOKIE'	
		WHEN (city ILIKE 'SOUTH%B%D%' OR city ILIKE 'SOUTH BEN%') AND city NOT ILIKE '%L%' THEN 'SOUTH BEND'	
		WHEN city ILIKE 'SOUTH EL%' THEN 'SOUTH ELGIN'	
		WHEN city ILIKE 'SOUTH HO%' OR city ILIKE 'SOUTH HL%' THEN 'SOUTH HOLLAND'	
		WHEN (city ILIKE '%LOUIS%' AND city NOT ILIKE '%VIL%') OR city ILIKE '%SAINT%LOUIS%' OR city ILIKE '%ST%LO%' OR city ILIKE 'ST%OUIS' THEN 'ST LOUIS'	
		WHEN city ILIKE 'STEG%' OR city ILIKE '%STEIGER%' THEN 'STEGER'		
		WHEN city ILIKE 'STERLI%' THEN 'STERLING'		
		WHEN city ILIKE 'STICK%' OR city ILIKE '%STICNEY%' OR city ILIKE 'STIKNEY' THEN 'STICKNEY'		
		WHEN city ILIKE 'STONE P%' OR city ILIKE '%STONE%PARK%' THEN 'STONE PARK'		
		WHEN city ILIKE 'STREAMW%' OR city ILIKE 'STREAM%OOD' OR city ILIKE 'STREEMWOOD' OR city ILIKE 'STREM%' THEN 'STREAMWOOD'		
		WHEN city ILIKE '%SUGAR%GROVE%' THEN 'SUGAR GROVE'		
		WHEN city ILIKE 'SUMMI%' OR city ILIKE 'SUMMT' THEN 'SUMMIT'		
		WHEN city ILIKE 'SYC%' THEN 'SYCAMORE'		
		WHEN city ILIKE 'TAMPA%' OR city ILIKE 'TAMOA%' THEN 'TAMPA'		
		WHEN city ILIKE 'THORN%' OR city ILIKE 'THONRTON' THEN 'THORNTON'		
		WHEN city ILIKE 'TINL%' OR city ILIKE 'TINELY%' OR city ILIKE 'TINNLEY PARK' OR city ILIKE 'TINNLEY PARK'OR city ILIKE 'TINTLEY PARK'  THEN 'TINLEY PARK'		
		WHEN city ILIKE 'TOLE%' OR city ILIKE 'TOLD%' THEN 'TOLEDO'		
		WHEN city ILIKE 'URBANA%' THEN 'URBANA'		
		WHEN city ILIKE 'VALO%' OR city ILIKE 'VALP%' OR city ILIKE 'VALR%' THEN 'VALPARAISO'		
		WHEN city ILIKE 'VIL% %' OR city ILIKE '%VIEW PARK%' OR city ILIKE 'VILLA' OR city ILIKE 'VILLAPARK' THEN 'VILLA PARK'		
		WHEN city ILIKE 'WARRE%' OR city ILIKE 'WARRNE%' OR city ILIKE 'WARENVILLE' THEN 'WARRENVILLE'		
		WHEN city ILIKE '%WASHINGTON%' OR city ILIKE 'WASH%TON%' THEN 'WASHINGTON'		
		WHEN city ILIKE 'WAUC%' THEN 'WAUCONDA'		
		WHEN city ILIKE 'WAU%GAN%' OR city ILIKE 'WAU%GON%' OR city ILIKE 'WAU%GEAN%' OR city ILIKE 'WAU%GEN%' OR city ILIKE 'WAUKEE' OR city ILIKE 'WAUGEKAN'  THEN 'WAUKEGAN'		
		WHEN city ILIKE 'WEST DU%' THEN 'WEST DUNDEE'		
		WHEN city ILIKE 'WESTC%' OR city ILIKE 'WESTERC%' THEN 'WESTCHESTER'		
		WHEN city ILIKE 'WESTERN S%' OR city ILIKE 'WESTERN  S%' OR city ILIKE 'WESTERN P%' OR city ILIKE 'WESTERNS%' THEN 'WESTERN SPRINGS'		
		WHEN city ILIKE 'WESTMON%' THEN 'WESTMONT'		
		WHEN city ILIKE 'WHEATO%' OR city ILIKE 'WHEATN%' OR city ILIKE 'WHEATION' OR city ILIKE 'WHET%' THEN 'WHEATON'		
		WHEN city ILIKE 'WHEE%' OR city ILIKE 'WHELE%' THEN 'WHEELING'		
		WHEN city ILIKE 'WILLOW S%' THEN 'WILLOW SPRINGS'		
		WHEN city ILIKE 'WILLOWB%' OR city ILIKE 'WILLOWR%' THEN 'WILLOWBROOK'		
		WHEN city ILIKE 'WINFI%' THEN 'WINFIELD'		
		WHEN city ILIKE 'WOO%DALE' OR city ILIKE 'WOOD D%' THEN 'WOOD DALE'		
		WHEN city ILIKE 'WOODR%' THEN 'WOODRIDGE'		
		WHEN city ILIKE 'WORT%' OR city ILIKE 'WORHT' OR city ILIKE 'WOTH' OR city ILIKE 'WPRTH' THEN 'WORTH'		
		WHEN city ILIKE 'YORKV%' THEN 'YORKVILLE'		
		WHEN city ILIKE 'ZIO%' THEN 'ZION'
		ELSE city
	END;

-- Unifing cities that have less than 100 entries
WITH city_counts AS (
    SELECT city, COUNT(*) AS count
    FROM cleaning.crashes_people 
    GROUP BY city
    HAVING COUNT(*) < 100
)
UPDATE cleaning.crashes_people AS cp
SET city = 'OTHER'
WHERE city IN (
	SELECT city
	FROM city_counts
);

UPDATE cleaning.crashes_people
SET city = 'OTHER'
WHERE city = '99';

/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */
-- Cleaning state
/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */

UPDATE cleaning.crashes_people
SET state = 'XX'
WHERE state IS NULL OR city = 'UNKNOWN' OR city = 'OTHER';

UPDATE cleaning.crashes_people AS cp
SET state = subquery.state
FROM (
    -- Subquery to find the city-state combination with the highest count for each city
    SELECT subquery.city, subquery.state
    FROM (
        -- Subquery to calculate the count of each city-state combination
        SELECT city, state, COUNT(*) AS city_count
        FROM cleaning.crashes_people
        GROUP BY city, state
    ) AS subquery
    INNER JOIN (
        -- Subquery to find the maximum count for each city
        SELECT city, MAX(city_count) AS max_city_count
        FROM (
            -- Subquery to calculate the count of each city-state combination
            SELECT city, state, COUNT(*) AS city_count
            FROM cleaning.crashes_people
            GROUP BY city, state
        ) AS subsubquery
        GROUP BY city
    ) AS max_counts ON subquery.city = max_counts.city AND subquery.city_count = max_counts.max_city_count
) AS subquery
WHERE cp.city = subquery.city; -- Join the main table with the subquery on the 'city' column

/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */
-- Cleaning zipcode
/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */

UPDATE cleaning.crashes_people
SET zipcode = 'UNKNOWN'
WHERE zipcode ILIKE '%UNK%' 
		OR zipcode ILIKE '%UN%K%' 
		OR zipcode ILIKE '%UK%' 
		OR zipcode ILIKE 'UN' 
		OR zipcode IS NULL
		OR zipcode ILIKE '%A%'
		OR zipcode ILIKE '%B%'
		OR zipcode ILIKE '%C%'
		OR zipcode ILIKE '%D%'
		OR zipcode ILIKE '%E%'
		OR zipcode ILIKE '%F%'
		OR zipcode ILIKE '%G%'
		OR zipcode ILIKE '%H%'
		OR zipcode ILIKE '%I%'
		OR zipcode ILIKE '%J%'
		OR zipcode ILIKE '%K%'
		OR zipcode ILIKE '%L%'
		OR zipcode ILIKE '%M%'
		OR zipcode ILIKE '%N%'
		OR zipcode ILIKE '%O%'
		OR zipcode ILIKE '%P%'
		OR zipcode ILIKE '%Q%'
		OR zipcode ILIKE '%R%'
		OR zipcode ILIKE '%S%'
		OR zipcode ILIKE '%T%'
		OR zipcode ILIKE '%U%'
		OR zipcode ILIKE '%V%'
		OR zipcode ILIKE '%W%'
		OR zipcode ILIKE '%X%'
		OR zipcode ILIKE '%Y%'
		OR zipcode ILIKE '%Z%'
		OR zipcode = '\'
		OR zipcode = '`';

UPDATE cleaning.crashes_people
SET zipcode =
	CASE
		WHEN zipcode = '.60636' THEN '60636'
		WHEN zipcode = '`60608' THEN '60608'
		WHEN zipcode = '`60614' THEN '60614'
		WHEN zipcode = '`60639' THEN '60639'
		WHEN zipcode = '`60804' THEN '60804'
		ELSE zipcode
	END;
	
/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */
-- Cleaning seat_no and person_type
/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */

--According to the column description, 1 = driver

UPDATE cleaning.crashes_people
SET seat_no = 1
WHERE person_type = 'DRIVER';

UPDATE cleaning.crashes_people
SET person_type = 'DRIVER'
WHERE person_type = 'PASSENGER' AND seat_no ='1';

/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */
-- Cleaning vehicle_id
/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */

UPDATE cleaning.crashes_people
SET vehicle_id = 'NO VEHICLE_ID'
WHERE vehicle_id IS NULL AND person_type = 'DRIVER';

/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */
-- Cleaning sex
/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */

--Assuming only two genders
UPDATE cleaning.crashes_people
SET sex = 'X'
WHERE sex IS NULL;

/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */
-- Cleaning age
/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */

UPDATE cleaning.crashes_people
SET age = NULL
WHERE age < 0; --Unknown age is NULL so it doesn't affect the numeric type

/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */
-- Cleaning safety_equipment
/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */

UPDATE cleaning.crashes_people
SET safety_equipment = 'USAGE UNKNOWN'
WHERE safety_equipment IS NULL;

/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */
-- Cleaning airbag_deployed
/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */

UPDATE cleaning.crashes_people
SET airbag_deployed = 
	CASE
		WHEN airbag_deployed = 'DEPLOYED OTHER (KNEE, AIR, BELT, ETC.)' THEN 'DEPLOYED, OTHER (KNEE, AIR, BELT, ETC.)'
		WHEN airbag_deployed IS NULL AND (person_type = 'BICYCLE' OR person_type = 'PEDESTRIAN' OR person_type = 'NON-CONTACT VEHICLE' OR person_type = 'NON-MOTOR VEHICLE') THEN 'NOT APPLICABLE'
		WHEN airbag_deployed IS NULL AND  (person_type = 'PASSENGER' OR person_type = 'DRIVER') THEN 'DEPLOYMENT UNKNOWN'
		ELSE airbag_deployed
	END;

/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */
-- Cleaning hospital 
/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */

SELECT hospital, COUNT(*)
FROM cleaning.crashes_people
GROUP BY hospital;

UPDATE cleaning.crashes_people
SET hospital =
	CASE
		WHEN hospital ILIKE '%HIT%AND%RUN%' OR hospital ILIKE '%HIT%&%RUN%' OR hospital ILIKE '%H&R%' OR hospital ILIKE '%HIT/RUN%' OR hospital ILIKE 'RUN FROM SCENE' THEN 'HIT AND RUN'
		WHEN (hospital ILIKE 'N % A' OR hospital = 'N / A' OR hospital = 'N' OR hospital ILIKE 'N.%' OR hospital ILIKE 'N/%' OR hospital = 'N;A' OR hospital ='NA/' OR hospital = 'N6E' OR hospital = 'NA' OR hospital ILIKE 'NM%' OR hospital ILIKE 'NN%' OR hospital = 'NKA' OR hospital = 'NO' OR hospital ILIKE 'NO %' OR hospital = 'NOE' OR hospital ILIKE 'NOEMS TREATMENT' OR hospital ILIKE 'CLAIM% N%INJ%' OR (hospital ILIKE '%NONE%' OR (hospital ILIKE '%NOT%' AND hospital NOT ILIKE '%ANOT%' AND hospital NOT ILIKE '%ON SCENE%') OR hospital ILIKE '%NO INJU%' OR hospital ILIKE '%NO  INJURY%' OR hospital ILIKE '%NO IJURY%' OR hospital ILIKE '%NO INKU%') AND hospital NOT ILIKE '%UNKNOWN%' AND hospital NOT ILIKE '%UNK%' AND hospital NOT ILIKE '%APPL%') OR hospital = 'N A' OR hospital = 'N-A' OR hospital = 'NANE' OR hospital ILIKE '%NJURY%' OR hospital ILIKE 'NON%' OR hospital = 'NOONE' OR hospital ILIKE '%UNINJURED%' THEN 'NO INJURY / CLAIM NO INJURY'
		WHEN hospital ILIKE '%SELF%' OR ((hospital ILIKE '%ON%OWN%' OR hospital ILIKE '%SEE%OWN%') AND hospital NOT ILIKE '%KNOWN%') OR hospital ILIKE '%FAMILY%' OR hospital ILIKE '%MOTHER%' OR hospital ILIKE '%FATHER%' OR hospital ILIKE '%HUSBAND%' OR hospital ILIKE '%WIFE%' OR hospital ILIKE '%PARENT%' OR hospital ILIKE '%PERSONAL%' OR hospital ILIKE '%PRIVATE%' OR hospital ILIKE 'SELT%' OR hospital ILIKE '%SEE HER%' OR hospital ILIKE '% UBER%' OR hospital ILIKE '%THEIR%' THEN 'SELF TRANSPORT'
		WHEN hospital ILIKE '%LATER%' OR hospital ILIKE '%NEXT%' OR hospital ILIKE '%FOLLOWING%' OR hospital ILIKE 'WILL%' THEN 'LATER'
		WHEN hospital ILIKE '%REFUSE%' OR hospital ILIKE '%DECLINE%' OR hospital ILIKE 'DECL%' OR hospital = 'DECKINED' OR hospital ILIKE 'DECI%' OR hospital = 'DECCLINED' OR hospital ILIKE 'DC%' OR hospital ILIKE '%DENIE%' OR hospital ILIKE '%RE%USA%' OR hospital ILIKE 'DIDN%' OR hospital = 'DEXCLINED' OR hospital = 'DENY' OR hospital = 'DENINED' OR hospital = 'DENCLINED' OR hospital ILIKE 'DELI%' OR hospital ILIKE 'DELC%' OR hospital = 'DEECLINED' OR hospital ILIKE '%DEDLINED%' OR hospital ILIKE '%DINIED%' OR hospital = 'DECXLINED' OR hospital ILIKE '%REEFUSED%' OR hospital ILIKE 'REF%' OR hospital ILIKE 'RER%' OR hospital ILIKE 'RESFUSED%' OR hospital ILIKE 'REU%' OR hospital ILIKE 'RFUS%' OR hospital ILIKE 'RUFUSED%' OR hospital ILIKE '%LEFT%' OR hospital ILIKE '%FLED%' OR hospital ILIKE 'DRIVER%' OR hospital ILIKE 'DROVE%' OR hospital ILIKE '%EFUSE%' OR hospital ILIKE '%USED' OR hospital ILIKE '%REF%' OR hospital ILIKE '%RTEFUSED%' OR hospital ILIKE '%RUFUSED%' OR hospital ILIKE '%RTEFUSED%' OR hospital ILIKE '%GONE%' OR hospital ILIKE 'R%E%FU%S%ED' OR hospital ILIKE 'REDUSED%' OR hospital ILIKE '%REJECTED%' OR hospital = 'RESUFED' OR hospital = 'RUFSED' THEN 'REFUSED OR LEFT THE SCENE'		
		WHEN hospital ILIKE '%UNK%' OR hospital ILIKE '%?%' OR hospital ILIKE 'NOT % ON SCENE%' OR hospital ILIKE 'UK%' OR hospital ILIKE 'UNIK%' OR hospital ILIKE 'UN%NOWN' OR hospital ILIKE 'UNNK%' OR hospital = 'UNNOWN' THEN 'UNKNOWN'
		WHEN (hospital ILIKE '%ON SCENE%' AND hospital NOT ILIKE '%NOT%' AND hospital NOT ILIKE 'REFUSED' AND hospital NOT ILIKE 'NO%') OR hospital ILIKE '%TREATED%' OR hospital ILIKE '%CHECKED%' THEN 'TREATED ON SCENE'
		WHEN hospital ILIKE '%DNA%' OR hospital ILIKE '%D%-%N%A%' OR hospital ILIKE '%D\%N%A%' OR hospital = 'DN' OR hospital ILIKE '%DID NOT APPLY%' OR hospital ILIKE '%D/A%' OR hospital = 'DA' OR hospital = 'DAN' OR hospital = 'DBA' OR hospital ILIKE '%D.%N%A%' OR hospital ILIKE '%D % N % A%' OR hospital ILIKE '%APPL%' OR hospital = 'D N A' OR hospital ILIKE 'D%/%N%/%A' OR hospital = 'DKA' OR hospital = 'DMA' OR hospital ILIKE 'DN%' OR hospital = 'DOA' AND hospital NOT ILIKE '%TELERADIOLOGY%'THEN 'DOES NOT APPLY'
		ELSE hospital 
	END;

UPDATE cleaning.crashes_people
SET hospital = 'HOSPITAL'
WHERE hospital IS NOT NULL AND hospital <> 'DOES NOT APPLY' AND hospital <> 'TREATED ON SCENE' AND hospital <> 'UNKNOWN' AND hospital <>  'REFUSED OR LEFT THE SCENE' AND hospital <>'LATER' AND hospital <> 'SELF TRANSPORT' AND hospital <> 'NO INJURY / CLAIM NO INJURY' AND hospital <> 'HIT AND RUN';

/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */
-- Cleaning ems_agency
/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */

UPDATE cleaning.crashes_people
SET ems_agency =
	CASE
		WHEN ems_agency ILIKE '%FUSED%' OR ems_agency ILIKE '%DECLINED%' OR ems_agency ILIKE 'DE%N%D' OR ems_agency ILIKE 'REF%' OR ems_agency ILIKE 'RED%' OR ems_agency ILIKE 'RES%' OR ems_agency = 'REUSED' OR ems_agency ILIKE '%DENIED%' OR ems_agency ILIKE '%REFUSES%' OR ems_agency ILIKE '%REQUEST%' OR ems_agency ILIKE '%REQQUEST%' OR ems_agency ILIKE '%REFUSAL%' OR ems_agency ILIKE '%REDUSED%' OR ems_agency ILIKE 'RF%ED' OR ems_agency = 'DCLINED' OR ems_agency ILIKE 'DECLINE%' THEN 'REFUSED'
		WHEN ems_agency ILIKE '%SELF%' OR ems_agency ILIKE '%PERSONAL%' OR ems_agency ILIKE 'SEK%' OR ems_agency ILIKE 'SEL%' OR (ems_agency ILIKE '%OWN%' AND ems_agency NOT ILIKE '%KNOWN%'AND ems_agency NOT ILIKE '%KOWN%') OR ems_agency ILIKE '%PRIVATE%' THEN 'SELF TRANSPORTED'
		WHEN ems_agency ILIKE '%DNA%' OR ems_agency = 'S-N-A' OR ems_agency ILIKE 'D %N%A%' OR ems_agency ILIKE '%D%-%N%A%' OR ems_agency ILIKE '%DOES%' OR ems_agency ILIKE 'D.N.A%' OR ems_agency = 'D/A' OR ems_agency = 'D/N/A' OR ems_agency = 'DA' OR ems_agency = 'DAN' OR ems_agency ='DN%' OR ems_agency = 'NOT APPLICABLE' THEN 'DOES NOT APPLY'
		WHEN ems_agency ILIKE '%AMBULANCE%' OR ems_agency ILIKE '%AMB%' OR ems_agency ILIKE '%ANB%' OR ems_agency ILIKE '%AUB%' OR ems_agency ILIKE '%ABM%' OR ems_agency ILIKE '%ABULANCE%' OR ems_agency ILIKE '%A #%' OR ems_agency ILIKE '%A 1%' OR ems_agency ILIKE '%A 2%' OR ems_agency ILIKE '%A 3%' OR ems_agency ILIKE '%A 4%' OR ems_agency ILIKE '%A 5%' OR ems_agency ILIKE '%A 6%' OR ems_agency ILIKE '%A 7%' OR ems_agency ILIKE '%A#%' OR ems_agency ILIKE '%A,%' OR ems_agency ILIKE '%A-%' OR ems_agency ILIKE '%A/4%' OR ems_agency ILIKE '%A/7%' OR (ems_agency ILIKE 'A%' AND ems_agency NOT ILIKE 'AD%' AND ems_agency NOT ILIKE 'AF%' AND ems_agency NOT ILIKE 'AL%') OR ems_agency ILIKE '%AB %' OR ems_agency ILIKE '%AB %' OR ems_agency ILIKE '%AB %' OR ems_agency ILIKE '%AB %' OR ems_agency ILIKE '%AB %' OR ems_agency ILIKE '%AB %' OR ems_agency ILIKE '%ANMBO%' OR ems_agency ILIKE '%AUMBULACE%' OR ems_agency ILIKE '%APM%' OR ems_agency ILIKE 'AMP%' OR ems_agency ILIKE 'CFD A%' THEN 'AMBULANCE'
		WHEN ems_agency ILIKE '%EMS%' OR (ems_agency ILIKE '%E%M%S%' AND ems_agency NOT ILIKE '%FAMILY%') OR ems_agency ILIKE 'EM%' THEN 'EMERGENCY MEDICAL SERVICES'
		WHEN (ems_agency ILIKE '%MED%' OR ems_agency ILIKE 'DR %' OR ems_agency ILIKE 'DR.%') AND ems_agency NOT ILIKE 'EMERGENCY MEDICAL SERVICES' OR ems_agency ILIKE '%HOSPITAL%' OR ems_agency ILIKE '%PARAMEDICS%' OR ems_agency ILIKE '%TREATED%' OR ems_agency ILIKE '%MD%' THEN 'MEDICAL'
		WHEN ems_agency ILIKE '%FAMILY%' OR ems_agency ILIKE '%BY%' OR ems_agency ILIKE '%DROVE%' OR ems_agency ILIKE '%DRIVE%' OR ems_agency ILIKE '%MOTHER%' OR ems_agency ILIKE '%FATHER%' OR ems_agency ILIKE '%BROTHER%' OR ems_agency ILIKE '%SISTER%' OR ems_agency ILIKE '%FRIEND%' OR ems_agency ILIKE '%HUSBAND%' OR ems_agency ILIKE '%WIFE%' OR ems_agency ILIKE '%PARENT%' THEN 'FRIEND OR FAMILY'
		WHEN ems_agency ILIKE '%NONE%' OR ems_agency ILIKE 'N%A' OR ems_agency = 'N/S' OR ems_agency = 'N0NE' OR ems_agency = 'NNE' OR ems_agency = 'NOME' OR ems_agency = 'NOE%' OR ems_agency = 'NO%NE' OR ems_agency = 'NO' OR ems_agency = 'NON%' OR ems_agency IS NULL OR ems_agency = 'N' OR ems_agency ILIKE '%N/A%' OR ems_agency = 'NA/' OR ems_agency = 'NIONE' OR ems_agency ILIKE 'NON%' OR ems_agency ILIKE 'NO %' OR ems_agency ILIKE 'NOE%' OR ems_agency ILIKE 'NOT%' OR ems_agency = 'NPNE' OR ems_agency = 'NQ' THEN 'NONE'
		WHEN ems_agency ILIKE '%FD%'  OR ems_agency ILIKE '%FIR%' OR ems_agency ILIKE '%FIE%' OR ems_agency ILIKE '%TRUCK%' OR ems_agency ILIKE '%TRK%' OR ems_agency ILIKE 'TK%' OR ems_agency ILIKE '%ENGINE%' OR ems_agency ILIKE '%ENG%' OR ems_agency ILIKE 'C.%' OR ems_agency ILIKE 'C,%' OR ems_agency ILIKE '%F.D%' OR ems_agency ='FCD' THEN 'FIRE DEPARTMENT'
		WHEN ems_agency ILIKE '%PD%' OR ems_agency ILIKE '%P%D%' OR ems_agency ILIKE '%POLICE%' OR ems_agency ILIKE '%1%' OR ems_agency ILIKE '%2%' OR ems_agency ILIKE '%3%' OR ems_agency ILIKE '%4%' OR ems_agency ILIKE '%5%' OR ems_agency ILIKE '%6%' OR ems_agency ILIKE '%7%' OR ems_agency ILIKE '%8%' OR ems_agency ILIKE '%9%' OR ems_agency ILIKE '%0%' THEN 'POLICE DEPARTMENT'
		WHEN ems_agency ILIKE 'UNK%' OR ems_agency ILIKE '%KNOWN%' OR ems_agency ILIKE 'UKN%' OR ems_agency ILIKE '%?%' OR ems_agency = '-' OR ems_agency ILIKE 'X%' THEN 'UNKNOWN'
		WHEN ems_agency ILIKE 'W%' THEN 'WALK IN'
		ELSE ems_agency
	END;

-- Unifing ems_agency that have less than 50 entries
WITH ems_agency_counts AS (
    SELECT ems_agency, COUNT(*) AS count
    FROM cleaning.crashes_people 
    GROUP BY ems_agency
    HAVING COUNT(*) <= 50
)
UPDATE cleaning.crashes_people AS cp
SET ems_agency = 'OTHER (FRIEND, FAMILY, VOLUNTARY, ETC)'
WHERE ems_agency IN (
	SELECT ems_agency
	FROM ems_agency_counts
);
--Simplifying the set
UPDATE cleaning.crashes_people
SET ems_agency =
	CASE
		WHEN ems_agency = 'EMERGENCY MEDICAL SERVICES' OR ems_agency = 'MEDICAL' THEN 'AMBULANCE'
		WHEN ems_agency = 'CHICAGO' THEN 'OTHER (FRIEND, FAMILY, VOLUNTARY, ETC)'
		ELSE ems_agency
	END;

/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */
-- Cleaning physical_condition
/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */

UPDATE cleaning.crashes_people
SET physical_condition = 'IMPAIRED - ALCOHOL'
WHERE physical_condition = 'HAD BEEN DRINKING';

/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */
-- Cleaning cell_phone_use
/* +++++++++++++++++++++++++++++++++++++++++++++++++++ */

UPDATE cleaning.crashes_people
SET cell_phone_use = 'X'
WHERE cell_phone_use IS NULL;

UPDATE cleaning.crashes_people
SET cell_phone_use = 'Y'
WHERE driver_action = 'TEXTING' OR driver_action = 'CELL PHONE USE OTHER THAN TEXTING';
