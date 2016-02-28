//for ASPX, use: http://stackoverflow.com/questions/9035817/asp-net-c-sharp-get-all-text-from-a-file-in-the-web-path
// - basically, server.mapPath();
//and then list all files of type png/gif/jpg
/*
 * ContentFlow logic:
 * 
 * on each link click:
 * 
 * 1: CLEAR container if already full
 * 2: build ContentFlow container PER CALL.
 * 3: Load, as DOM structure compatable with ContentFlow Items, a sub-array by category
 * 4: push above onto contentflow container items node
 * 5: Only when full structure is built, initialise ContentFlow instance. 
 * 
 * @type type
 */

var weddingfest07 = {
    
    //config (adapted from original weddingfest07 controller, so apologies for crappy code...):
    THUMBPREFIX : "thmb_",
    IMGPATH         : "/weddingfest07/images/gallery/",
    THUMBPATH       : "/images/gallery/thmb/", //TODO

    //categories:
    categories : {
        //ALL_IMAGES          : -1,
        EVENT_SETUP_DAY1    : {id:10,name:"Setup, day 1"},
        EVENT_SETUP_DAY2    : {id:11,name:"Setup, day 2"},
        EVENT_CEREMONY      : {id:20,name:"Ceremony"},
        EVENT_DINNER        : {id:30,name:"Dinner #1"},
        //EVENT_ARRIVAL       : {id:31,name:"Arrival"},
        EVENT_DINNER2       : {id:40,name:"Dinner #2"},
        EVENT_PARTY1        : {id:41,name:"Party #1"},
        EVENT_PARTY2        : {id:42,name:"Party #2"},
        EVENT_HANGOVER      : {id:50,name:"Hangover"},

        //honeymoon
        HM_GENERAL          : {id:60,name:"Honeymoon"},
        HM_SHED             : {id:70,name:"Honeymoon - shed!"},
        HM_FORT             : {id:80,name:"Honeymoon - fort"},
        HM_SADDELL          : {id:90,name:"Honeymoon - Saddell"},
        HM_WWHEEL           : {id:100,name:"Honeymoon - waterwheel"},
        HM_SKIPNESS         : {id:110,name:"Honeymoon - Skipness"},
        HM_SFCABIN          : {id:120,name:"Honeymoon - SF Cabin"},
        HM_TARBERT          : {id:130,name:"Honeymoon - Tarbert"},
        HM_KILBERRY         : {id:140,name:"Honeymoon - Kilberry"},
        HM_OWL              : {id:150,name:"Honeymoon - owls"},
        HM_HOME             : {id:160,name:"Honeymoon - home!"},
        HM_WESTPORT         : {id:170,name:"Honeymoon - Westport"},
        HM_GDNS             : {id:180,name:"Honeymoon - botanic gardens"},
        HM_OTHER            : {id:190,name:"Honeymoon - other stuff"},

        TEST                : {id:999,name:"TEST"}
    },
    
    ContentFlowConfig : null,
    ContentFlowInstance : null,
    
    //Image data:
    arr : new Array(),

/*
 * 
 * @param {type} config = {displaytargetId : "target_id",linksTargetId : "links_list_id"}
 * @returns {undefined}
 */
    init : function(config){
        
        this.ContentFlowConfig = config;
        
        //load the data into the array:
        this.loadImageArray();
        
        //NEW: Build ALL images:
        
        /*
         * Once we have this, we can push arrays of images onto it - hopefully...
         */
        this.buildFlowLinks();
    },

    /*
     * Load the images:
     * @returns {undefined}
     */
    loadImageArray : function(){
        //console.log("Loading images");
        this.arr.push({src:"BLANK",orientation:0,alt:""});
        //setup
        this.arr.push({src:"web_0002.jpg",orientation:0,alt:"Car park before the quagmire",  category : this.categories.EVENT_SETUP_DAY1.id});
        this.arr.push({src:"web_0003.jpg",orientation:1,alt:"The old dead tree",             category : this.categories.EVENT_SETUP_DAY1.id});
        this.arr.push({src:"web_0005.jpg",orientation:0,alt:"Mike&#39;s truck far away!",    category : this.categories.EVENT_SETUP_DAY1.id});
        this.arr.push({src:"web_0008.jpg",orientation:0,alt:"Pretty trees and hubby to be",  category : this.categories.EVENT_SETUP_DAY1.id});
        this.arr.push({src:"web_0009.jpg",orientation:0,alt:"Me and my car",                 category : this.categories.EVENT_SETUP_DAY1.id});
        this.arr.push({src:"web_0012.jpg",orientation:0,alt:"The Bimble Inn naked!",         category : this.categories.EVENT_SETUP_DAY1.id});
        this.arr.push({src:"web_0014.jpg",orientation:0,alt:"More naked Bimble Inn",         category : this.categories.EVENT_SETUP_DAY1.id});
        this.arr.push({src:"web_0015.jpg",orientation:0,alt:"Mike&#39;s truck hiding behind some trees", category : this.categories.EVENT_SETUP_DAY1.id});

        //pre-event dinner
        this.arr.push({src:"web_0022.jpg",orientation:0,alt:"",category : this.categories.EVENT_DINNER.id});
        this.arr.push({src:"web_0027.jpg",orientation:0,alt:"",category : this.categories.EVENT_DINNER.id});
        this.arr.push({src:"web_0028.jpg",orientation:0,alt:"",category : this.categories.EVENT_DINNER.id});
        this.arr.push({src:"web_0030.jpg",orientation:0,alt:"",category : this.categories.EVENT_DINNER.id});
        this.arr.push({src:"web_0034.jpg",orientation:0,alt:"",category : this.categories.EVENT_DINNER.id});
        this.arr.push({src:"web_0035.jpg",orientation:0,alt:"",category : this.categories.EVENT_DINNER.id});
        this.arr.push({src:"web_0036.jpg",orientation:0,alt:"",category : this.categories.EVENT_DINNER.id});
        this.arr.push({src:"web_0037.jpg",orientation:0,alt:"",category : this.categories.EVENT_DINNER.id});
        this.arr.push({src:"web_0038.jpg",orientation:0,alt:"",category : this.categories.EVENT_DINNER.id});
        this.arr.push({src:"web_0039.jpg",orientation:0,alt:"",category : this.categories.EVENT_DINNER.id});
        this.arr.push({src:"web_0041.jpg",orientation:0,alt:"",category : this.categories.EVENT_DINNER.id});
        this.arr.push({src:"web_0042.jpg",orientation:0,alt:"",category : this.categories.EVENT_DINNER.id});
        this.arr.push({src:"web_0043.jpg",orientation:0,alt:"",category : this.categories.EVENT_DINNER.id});
        this.arr.push({src:"web_0044.jpg",orientation:0,alt:"",category : this.categories.EVENT_DINNER.id});
        this.arr.push({src:"web_0046.jpg",orientation:0,alt:"",category : this.categories.EVENT_DINNER.id});

        //setup before party
        this.arr.push({src:"web_0048.jpg",orientation:0,alt:"Straw spreading",category : this.categories.EVENT_SETUP_DAY2.id});
        this.arr.push({src:"web_0049.jpg",orientation:0,alt:"Straw spreading",category : this.categories.EVENT_SETUP_DAY2.id});
        this.arr.push({src:"web_0059.jpg",orientation:0,alt:"The Bimble entrance",category : this.categories.EVENT_SETUP_DAY2.id});
        this.arr.push({src:"web_0062.jpg",orientation:0,alt:"The Bimble Inn Sign",category : this.categories.EVENT_SETUP_DAY2.id});
        this.arr.push({src:"dscf1662.jpg",orientation:2,alt:"The Bimble Inn side view",category : this.categories.EVENT_SETUP_DAY2.id});
        this.arr.push({src:"dscf1652.jpg",orientation:2,alt:"The Bimble Inn sign",category : this.categories.EVENT_SETUP_DAY2.id});
        this.arr.push({src:"dscf0217.jpg",orientation:0,alt:"The Bimble Inn ",category : this.categories.EVENT_SETUP_DAY2.id});
        this.arr.push({src:"dscf1658.jpg",orientation:2,alt:"The crows nest",category : this.categories.EVENT_SETUP_DAY2.id});
        this.arr.push({src:"dscf1650.jpg",orientation:2,alt:"The honeymoon tipee",category : this.categories.EVENT_SETUP_DAY2.id});
        this.arr.push({src:"dscf0216.jpg",orientation:1,alt:"The honeymoon tipee",category : this.categories.EVENT_SETUP_DAY2.id});
        this.arr.push({src:"dscf1661.jpg",orientation:2,alt:"The honeymoon tipee",category : this.categories.EVENT_SETUP_DAY2.id});
        this.arr.push({src:"dscf1651.jpg",orientation:2,alt:"The hordes gather...",category : this.categories.EVENT_SETUP_DAY2.id});
        this.arr.push({src:"dscf1660.jpg",orientation:2,alt:"The most important building in the world...",category : this.categories.EVENT_SETUP_DAY2.id});
        this.arr.push({src:"dscf1655.jpg",orientation:2,alt:"People start to arrive",category : this.categories.EVENT_SETUP_DAY2.id});
        this.arr.push({src:"web_0052.jpg",orientation:0,alt:"FOTB...",category : this.categories.EVENT_SETUP_DAY2.id});
        this.arr.push({src:"web_0054.jpg",orientation:0,alt:"FOTG...",category : this.categories.EVENT_SETUP_DAY2.id});
        this.arr.push({src:"web_0055.jpg",orientation:0,alt:"FOTG...",category : this.categories.EVENT_SETUP_DAY2.id});
        this.arr.push({src:"dscf0212.jpg",orientation:1,alt:"FOTG... and small niece",category : this.categories.EVENT_SETUP_DAY2.id});
        this.arr.push({src:"web_0063.jpg",orientation:0,alt:"A small tractor-mower!",category : this.categories.EVENT_SETUP_DAY2.id});
        this.arr.push({src:"web_0060.jpg",orientation:0,alt:"Charlotte helps out again",category : this.categories.EVENT_SETUP_DAY2.id});
        this.arr.push({src:"dscf1654.jpg",orientation:2,alt:"Other people sit down...",category : this.categories.EVENT_SETUP_DAY2.id});
        this.arr.push({src:"dscf1664.jpg",orientation:2,alt:"The stage",category : this.categories.EVENT_SETUP_DAY2.id});
        this.arr.push({src:"dscf1665.jpg",orientation:3,alt:"",category : this.categories.EVENT_SETUP_DAY2.id});

        //pre-ceremony drinks
        this.arr.push({src:"dscf1741.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1742.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1743.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1744.jpg",orientation:3,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1745.jpg",orientation:3,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1746.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1747.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1748.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1749.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1750.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1751.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1752.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1753.jpg",orientation:3,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1754.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1756.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1757.jpg",orientation:3,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1759.jpg",orientation:3,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1760.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1761.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1762.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1764.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1765.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1766.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1767.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1768.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1770.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1771.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1772.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1773.jpg",orientation:3,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1774.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1775.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1776.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1777.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1778.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1779.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1780.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1781.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1782.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1783.jpg",orientation:3,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1784.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1785.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1786.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1787.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1788.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1789.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1790.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1793.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1794.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1795.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1797.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1798.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1800.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1803.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1805.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1806.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1807.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1808.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1809.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1810.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1811.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1812.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1813.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1814.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1815.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1816.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1817.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1818.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1819.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1820.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1821.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1822.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1824.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1825.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1826.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1827.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1828.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1830.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1831.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1832.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1833.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1834.jpg",orientation:3,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1835.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1836.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1837.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1839.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1840.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1841.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1842.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1844.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1845.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1846.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1847.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1848.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});
        this.arr.push({src:"dscf1849.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY1.id});

        //ceremony
        this.arr.push({src:"mum_giving_welcome_speech.jpg",orientation:1,alt:"",category : this.categories.EVENT_CEREMONY.id});
        this.arr.push({src:"walking_down_aisle.jpg",     orientation:1,alt:"",category : this.categories.EVENT_CEREMONY.id});
        this.arr.push({src:"bride_arrives.jpg",          orientation:2,alt:"",category : this.categories.EVENT_CEREMONY.id});
        this.arr.push({src:"joes_intro.jpg",             orientation:0,alt:"",category : this.categories.EVENT_CEREMONY.id});
        this.arr.push({src:"bridesmaids.jpg",            orientation:1,alt:"",category : this.categories.EVENT_CEREMONY.id});
        this.arr.push({src:"clare_roses.jpg",            orientation:0,alt:"",category : this.categories.EVENT_CEREMONY.id});
        this.arr.push({src:"zu_reading.jpg",             orientation:0,alt:"",category : this.categories.EVENT_CEREMONY.id});
        this.arr.push({src:"zu_lois.jpg",                orientation:1,alt:"",category : this.categories.EVENT_CEREMONY.id});
        this.arr.push({src:"zulois1.jpg",                orientation:1,alt:"",category : this.categories.EVENT_CEREMONY.id});
        this.arr.push({src:"marc_reading.jpg",           orientation:0,alt:"",category : this.categories.EVENT_CEREMONY.id});
        this.arr.push({src:"taking_vows_2.jpg",          orientation:0,alt:"",category : this.categories.EVENT_CEREMONY.id});
        this.arr.push({src:"taking_vows_portrait.jpg",   orientation:1,alt:"",category : this.categories.EVENT_CEREMONY.id});
        this.arr.push({src:"taking_vows_landscape.jpg",  orientation:0,alt:"",category : this.categories.EVENT_CEREMONY.id});
        this.arr.push({src:"forging_the_ring.jpg",       orientation:0,alt:"",category : this.categories.EVENT_CEREMONY.id});
        this.arr.push({src:"clement_speech.jpg",         orientation:0,alt:"",category : this.categories.EVENT_CEREMONY.id});
        this.arr.push({src:"forging_the_ring2.jpg",      orientation:0,alt:"",category : this.categories.EVENT_CEREMONY.id});
        this.arr.push({src:"joe_marc_working.jpg",       orientation:1,alt:"",category : this.categories.EVENT_CEREMONY.id});
        this.arr.push({src:"forging_wide.jpg",           orientation:0,alt:"",category : this.categories.EVENT_CEREMONY.id});
        this.arr.push({src:"gui_joe_fire.jpg",           orientation:0,alt:"",category : this.categories.EVENT_CEREMONY.id});
        this.arr.push({src:"forging_wide2.jpg",          orientation:0,alt:"",category : this.categories.EVENT_CEREMONY.id});
        this.arr.push({src:"hammering.jpg",              orientation:0,alt:"",category : this.categories.EVENT_CEREMONY.id});
        this.arr.push({src:"listening.jpg",              orientation:1,alt:"",category : this.categories.EVENT_CEREMONY.id});
        this.arr.push({src:"perfecting_the_circle.jpg",  orientation:0,alt:"",category : this.categories.EVENT_CEREMONY.id});
        this.arr.push({src:"tempering_the_ring.jpg",     orientation:1,alt:"",category : this.categories.EVENT_CEREMONY.id});
        this.arr.push({src:"joes_view.jpg",              orientation:0,alt:"",category : this.categories.EVENT_CEREMONY.id});
        this.arr.push({src:"jaz_singing.jpg",            orientation:0,alt:"",category : this.categories.EVENT_CEREMONY.id});
        this.arr.push({src:"jaz_singing2.jpg",           orientation:0,alt:"",category : this.categories.EVENT_CEREMONY.id});
        this.arr.push({src:"ring_vows.jpg",              orientation:0,alt:"",category : this.categories.EVENT_CEREMONY.id});
        this.arr.push({src:"ring_vows2.jpg",             orientation:0,alt:"",category : this.categories.EVENT_CEREMONY.id});
        this.arr.push({src:"ring_vows3.jpg",             orientation:1,alt:"",category : this.categories.EVENT_CEREMONY.id});
        this.arr.push({src:"ring_vows4.jpg",             orientation:0,alt:"",category : this.categories.EVENT_CEREMONY.id});
        this.arr.push({src:"the_pronouncement.jpg",      orientation:0,alt:"",category : this.categories.EVENT_CEREMONY.id});
        this.arr.push({src:"happy_couple2.jpg",          orientation:1,alt:"",category : this.categories.EVENT_CEREMONY.id});
        this.arr.push({src:"happy_couple.jpg",           orientation:1,alt:"",category : this.categories.EVENT_CEREMONY.id});
        this.arr.push({src:"first_kiss.jpg",             orientation:1,alt:"",category : this.categories.EVENT_CEREMONY.id});

        //meal
        this.arr.push({src:"dscf1855.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1857.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1858.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1859.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1860.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1861.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1862.jpg",orientation:3,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1863.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1864.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1865.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1866.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1867.jpg",orientation:3,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1869.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1871.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1872.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1873.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1874.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1875.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1878.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1879.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1880.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1881.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1882.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1884.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1885.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1886.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1888.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1889.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1890.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1891.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1892.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1893.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1894.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1895.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1896.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1897.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1898.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1900.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1901.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1902.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1903.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1908.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1913.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1914.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1915.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1918.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1923.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1924.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1925.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1927.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1934.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1935.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1936.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1937.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1941.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1942.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1943.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1944.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1945.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1946.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1947.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1948.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1949.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1950.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1951.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1952.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1956.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1960.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1961.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1963.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1964.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1965.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1966.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1967.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1968.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1969.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1970.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1971.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1972.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1973.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1975.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1976.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1977.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1978.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1980.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1981.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1982.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1983.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1985.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1986.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1987.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1988.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1989.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1990.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1991.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1992.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1993.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1994.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1995.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1996.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1997.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1998.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf1999.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf2000.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf2001.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf2002.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf2003.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf2004.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf2007.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf2011.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf2012.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf2014.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf2015.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf2016.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf2017.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf2018.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf2019.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf2021.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf2024.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf2025.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf2026.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf2027.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf2030.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf2033.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf2034.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf2036.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf2037.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf2038.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf2039.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf2040.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf2041.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf2042.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf2043.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf2044.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf2045.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});
        this.arr.push({src:"dscf2046.jpg",orientation:2,alt:"",category : this.categories.EVENT_DINNER2.id});

        //the party
        this.arr.push({src:"web_img_2082_1024.jpg",orientation:0,alt:"First dance",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2065.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2069.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2077.jpg",orientation:3,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2082.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2082_1024.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2087.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2088.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2089.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2096.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2101.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2102.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2103.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2109.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2111.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2121.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2122.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2132.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2148.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2152.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2154.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2160.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2161.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2162.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2166.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2167.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2172.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2183.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2187.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2194.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2204.jpg",orientation:3,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2205.jpg",orientation:3,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2207.jpg",orientation:3,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2215.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2216.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2230.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2236.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2245.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2248.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2286.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2289.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2290.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2300.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2310.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2311.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2337.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2346.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2352.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2363.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2364.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2366.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2368.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2371.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2376.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2384.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2385.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2392.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2414.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2420.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2433.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2439.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2450.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2451.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2457.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2459.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2465.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2466.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2493.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2499.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2508.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"dscf2547.jpg",orientation:2,alt:"",category : this.categories.EVENT_PARTY2.id});
        this.arr.push({src:"web_0066.jpg",orientation:0,alt:"",category : this.categories.EVENT_HANGOVER.id});
        this.arr.push({src:"web_0067.jpg",orientation:0,alt:"",category : this.categories.EVENT_HANGOVER.id});

        //honeymoon
        this.arr.push({src:"web_0093.jpg",orientation:0,alt:"",category : this.categories.HM_HOME.id});
        this.arr.push({src:"web_0094.jpg",orientation:0,alt:"",category : this.categories.HM_HOME.id});
        this.arr.push({src:"web_0101.jpg",orientation:0,alt:"",category : this.categories.HM_HOME.id});
        this.arr.push({src:"web_0102.jpg",orientation:0,alt:"",category : this.categories.HM_HOME.id});
        this.arr.push({src:"web_0095.jpg",orientation:0,alt:"",category : this.categories.HM_HOME.id});
        this.arr.push({src:"web_0142.jpg",orientation:0,alt:"",category : this.categories.HM_HOME.id});
        this.arr.push({src:"web_0148.jpg",orientation:0,alt:"",category : this.categories.HM_HOME.id});
        this.arr.push({src:"web_0151.jpg",orientation:0,alt:"",category : this.categories.HM_HOME.id});
        this.arr.push({src:"web_0253.jpg",orientation:0,alt:"",category : this.categories.HM_HOME.id});
        this.arr.push({src:"web_0353.jpg",orientation:0,alt:"Shags plunge diving",category : this.categories.HM_HOME.id});
        this.arr.push({src:"web_0334.jpg",orientation:0,alt:"Dwarves here!",category : this.categories.HM_HOME.id});
        this.arr.push({src:"web_0574.jpg",orientation:0,alt:"",category : this.categories.HM_HOME.id});
        this.arr.push({src:"web_0576.jpg",orientation:1,alt:"",category : this.categories.HM_HOME.id});
        this.arr.push({src:"web_0610.jpg",orientation:0,alt:"",category : this.categories.HM_HOME.id});

        //wildlife observatory
        this.arr.push({src:"web_0103.jpg",orientation:0,alt:"",category : this.categories.HM_SHED.id});
        this.arr.push({src:"web_0104.jpg",orientation:0,alt:"",category : this.categories.HM_SHED.id});
        this.arr.push({src:"hm_seal1.jpg",orientation:0,alt:"",category : this.categories.HM_SHED.id});
        this.arr.push({src:"hm_seal2.jpg",orientation:0,alt:"",category : this.categories.HM_SHED.id});
        this.arr.push({src:"hm_seal3.jpg",orientation:0,alt:"",category : this.categories.HM_SHED.id});
        this.arr.push({src:"hm_seal4.jpg",orientation:0,alt:"",category : this.categories.HM_SHED.id});
        this.arr.push({src:"hm_seal5.jpg",orientation:0,alt:"",category : this.categories.HM_SHED.id});
        this.arr.push({src:"hm_seal6.jpg",orientation:0,alt:"",category : this.categories.HM_SHED.id});
        this.arr.push({src:"hm_seal7.jpg",orientation:0,alt:"",category : this.categories.HM_SHED.id});
        this.arr.push({src:"web_0108.jpg",orientation:0,alt:"",category : this.categories.HM_SHED.id});
        this.arr.push({src:"web_0109.jpg",orientation:0,alt:"",category : this.categories.HM_SHED.id});
        this.arr.push({src:"web_0110.jpg",orientation:0,alt:"",category : this.categories.HM_SHED.id});
        this.arr.push({src:"web_0112.jpg",orientation:0,alt:"",category : this.categories.HM_SHED.id});
        this.arr.push({src:"web_0113.jpg",orientation:0,alt:"",category : this.categories.HM_SHED.id});
        this.arr.push({src:"web_0114.jpg",orientation:0,alt:"",category : this.categories.HM_SHED.id});
        this.arr.push({src:"web_0115.jpg",orientation:0,alt:"",category : this.categories.HM_SHED.id});
        this.arr.push({src:"web_0116.jpg",orientation:0,alt:"",category : this.categories.HM_SHED.id});
        this.arr.push({src:"web_0117.jpg",orientation:0,alt:"",category : this.categories.HM_SHED.id});

        //Kildonan Dun
        this.arr.push({src:"web_0153.jpg",orientation:1,alt:"",category : this.categories.HM_FORT.id});
        this.arr.push({src:"web_0154.jpg",orientation:0,alt:"",category : this.categories.HM_FORT.id});
        this.arr.push({src:"web_0155.jpg",orientation:0,alt:"",category : this.categories.HM_FORT.id});
        this.arr.push({src:"web_0156.jpg",orientation:0,alt:"",category : this.categories.HM_FORT.id});
        this.arr.push({src:"web_0157.jpg",orientation:0,alt:"",category : this.categories.HM_FORT.id});
        this.arr.push({src:"web_0159.jpg",orientation:0,alt:"",category : this.categories.HM_FORT.id});
        this.arr.push({src:"web_0160.jpg",orientation:0,alt:"",category : this.categories.HM_FORT.id});
        this.arr.push({src:"web_0161.jpg",orientation:0,alt:"",category : this.categories.HM_FORT.id});
        this.arr.push({src:"web_0162.jpg",orientation:0,alt:"",category : this.categories.HM_FORT.id});
        this.arr.push({src:"web_0163.jpg",orientation:0,alt:"",category : this.categories.HM_FORT.id});
        this.arr.push({src:"web_0164.jpg",orientation:0,alt:"",category : this.categories.HM_FORT.id});
        this.arr.push({src:"web_0165.jpg",orientation:0,alt:"",category : this.categories.HM_FORT.id});
        this.arr.push({src:"web_0167.jpg",orientation:0,alt:"",category : this.categories.HM_FORT.id});
        this.arr.push({src:"web_0169.jpg",orientation:1,alt:"",category : this.categories.HM_FORT.id});
        this.arr.push({src:"web_0173.jpg",orientation:0,alt:"",category : this.categories.HM_FORT.id});
        this.arr.push({src:"web_0174.jpg",orientation:0,alt:"",category : this.categories.HM_FORT.id});
        this.arr.push({src:"web_0175.jpg",orientation:0,alt:"",category : this.categories.HM_FORT.id});

        //saddell abbey
        this.arr.push({src:"web_0176.jpg",orientation:0,alt:"",category : this.categories.HM_SADDELL.id});
        this.arr.push({src:"web_0177.jpg",orientation:0,alt:"",category : this.categories.HM_SADDELL.id});
        this.arr.push({src:"web_0178.jpg",orientation:1,alt:"",category : this.categories.HM_SADDELL.id});
        this.arr.push({src:"web_0179.jpg",orientation:0,alt:"",category : this.categories.HM_SADDELL.id});
        this.arr.push({src:"web_0180.jpg",orientation:1,alt:"",category : this.categories.HM_SADDELL.id});
        this.arr.push({src:"web_0181.jpg",orientation:0,alt:"",category : this.categories.HM_SADDELL.id});
        this.arr.push({src:"web_0183.jpg",orientation:0,alt:"",category : this.categories.HM_SADDELL.id});
        this.arr.push({src:"web_0185.jpg",orientation:0,alt:"",category : this.categories.HM_SADDELL.id});
        this.arr.push({src:"web_0187.jpg",orientation:0,alt:"",category : this.categories.HM_SADDELL.id});
        this.arr.push({src:"web_0189.jpg",orientation:0,alt:"",category : this.categories.HM_SADDELL.id});
        this.arr.push({src:"web_0190.jpg",orientation:0,alt:"",category : this.categories.HM_SADDELL.id});
        this.arr.push({src:"web_0192.jpg",orientation:0,alt:"",category : this.categories.HM_SADDELL.id});
        this.arr.push({src:"web_0194.jpg",orientation:0,alt:"",category : this.categories.HM_SADDELL.id});

        //carradale water mill
        this.arr.push({src:"web_0196.jpg",orientation:1,alt:"",category : this.categories.HM_WWHEEL.id});
        this.arr.push({src:"web_0195.jpg",orientation:0,alt:"",category : this.categories.HM_WWHEEL.id});

        //skipness castle
        this.arr.push({src:"web_0197.jpg",orientation:0,alt:"",category : this.categories.HM_SKIPNESS.id});
        this.arr.push({src:"web_0199.jpg",orientation:0,alt:"",category : this.categories.HM_SKIPNESS.id});
        this.arr.push({src:"web_0200.jpg",orientation:0,alt:"",category : this.categories.HM_SKIPNESS.id});
        this.arr.push({src:"web_0201.jpg",orientation:0,alt:"",category : this.categories.HM_SKIPNESS.id});
        this.arr.push({src:"web_0202.jpg",orientation:0,alt:"",category : this.categories.HM_SKIPNESS.id});
        this.arr.push({src:"web_0203.jpg",orientation:0,alt:"",category : this.categories.HM_SKIPNESS.id});
        this.arr.push({src:"web_0204.jpg",orientation:1,alt:"",category : this.categories.HM_SKIPNESS.id});
        this.arr.push({src:"web_0205.jpg",orientation:0,alt:"",category : this.categories.HM_SKIPNESS.id});
        this.arr.push({src:"web_0206.jpg",orientation:0,alt:"",category : this.categories.HM_SKIPNESS.id});
        this.arr.push({src:"web_0208.jpg",orientation:1,alt:"",category : this.categories.HM_SKIPNESS.id});
        this.arr.push({src:"web_0209.jpg",orientation:0,alt:"",category : this.categories.HM_SKIPNESS.id});
        this.arr.push({src:"web_0212.jpg",orientation:1,alt:"",category : this.categories.HM_SKIPNESS.id});
        this.arr.push({src:"web_0218.jpg",orientation:0,alt:"",category : this.categories.HM_SKIPNESS.id});
        this.arr.push({src:"web_0221.jpg",orientation:0,alt:"",category : this.categories.HM_SKIPNESS.id});
        this.arr.push({src:"web_0222.jpg",orientation:0,alt:"",category : this.categories.HM_SKIPNESS.id});
        this.arr.push({src:"web_0224.jpg",orientation:0,alt:"",category : this.categories.HM_SKIPNESS.id});
        this.arr.push({src:"web_0226.jpg",orientation:1,alt:"",category : this.categories.HM_SKIPNESS.id});
        this.arr.push({src:"web_0228.jpg",orientation:1,alt:"",category : this.categories.HM_SKIPNESS.id});
        this.arr.push({src:"web_0230.jpg",orientation:1,alt:"",category : this.categories.HM_SKIPNESS.id});
        this.arr.push({src:"web_0232.jpg",orientation:0,alt:"",category : this.categories.HM_SKIPNESS.id});
        this.arr.push({src:"web_0233.jpg",orientation:0,alt:"",category : this.categories.HM_SKIPNESS.id});
        this.arr.push({src:"web_0234.jpg",orientation:0,alt:"",category : this.categories.HM_SKIPNESS.id});
        this.arr.push({src:"web_0235.jpg",orientation:1,alt:"",category : this.categories.HM_SKIPNESS.id});
        this.arr.push({src:"web_0236.jpg",orientation:1,alt:"",category : this.categories.HM_SKIPNESS.id});
        this.arr.push({src:"web_0237.jpg",orientation:0,alt:"",category : this.categories.HM_SKIPNESS.id});

        //seafood cabin
        this.arr.push({src:"web_0238.jpg",orientation:0,alt:"",category : this.categories.HM_SFCABIN.id});
        this.arr.push({src:"web_0239.jpg",orientation:0,alt:"",category : this.categories.HM_SFCABIN.id});
        this.arr.push({src:"web_0240.jpg",orientation:0,alt:"",category : this.categories.HM_SFCABIN.id});
        this.arr.push({src:"web_0241.jpg",orientation:0,alt:"",category : this.categories.HM_SFCABIN.id});

        //tarbert
        this.arr.push({src:"web_0262.jpg",orientation:0,alt:"",category : this.categories.HM_TARBERT.id});
        this.arr.push({src:"web_0263.jpg",orientation:0,alt:"",category : this.categories.HM_TARBERT.id});
        this.arr.push({src:"web_0264.jpg",orientation:0,alt:"",category : this.categories.HM_TARBERT.id});
        this.arr.push({src:"web_0265.jpg",orientation:0,alt:"",category : this.categories.HM_TARBERT.id});
        this.arr.push({src:"web_0266.jpg",orientation:0,alt:"",category : this.categories.HM_TARBERT.id});
        this.arr.push({src:"web_0267.jpg",orientation:0,alt:"",category : this.categories.HM_TARBERT.id});
        this.arr.push({src:"web_0268.jpg",orientation:0,alt:"",category : this.categories.HM_TARBERT.id});
        this.arr.push({src:"web_0269.jpg",orientation:0,alt:"",category : this.categories.HM_TARBERT.id});
        this.arr.push({src:"web_0270.jpg",orientation:1,alt:"",category : this.categories.HM_TARBERT.id});
        this.arr.push({src:"web_0272.jpg",orientation:0,alt:"",category : this.categories.HM_TARBERT.id});
        this.arr.push({src:"web_0273.jpg",orientation:0,alt:"",category : this.categories.HM_TARBERT.id});

        //kilberry stones
        this.arr.push({src:"web_0289.jpg",orientation:0,alt:"",category : this.categories.HM_KILBERRY.id});
        this.arr.push({src:"web_0276.jpg",orientation:1,alt:"",category : this.categories.HM_KILBERRY.id});
        this.arr.push({src:"web_0277.jpg",orientation:1,alt:"",category : this.categories.HM_KILBERRY.id});
        this.arr.push({src:"web_0278.jpg",orientation:0,alt:"",category : this.categories.HM_KILBERRY.id});
        this.arr.push({src:"web_0279.jpg",orientation:1,alt:"",category : this.categories.HM_KILBERRY.id});
        this.arr.push({src:"web_0281.jpg",orientation:1,alt:"",category : this.categories.HM_KILBERRY.id});
        this.arr.push({src:"web_0283.jpg",orientation:1,alt:"",category : this.categories.HM_KILBERRY.id});
        this.arr.push({src:"web_0284.jpg",orientation:1,alt:"",category : this.categories.HM_KILBERRY.id});
        this.arr.push({src:"web_0285.jpg",orientation:0,alt:"",category : this.categories.HM_KILBERRY.id});

        //scottish owl centre
        this.arr.push({src:"web_0375.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0376.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0367.jpg",orientation:1,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0369.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0368.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0372.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0370.jpg",orientation:1,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0371.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0374.jpg",orientation:1,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0373.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0377.jpg",orientation:1,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0378.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0384.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0383.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0390.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0385.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0389.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0392.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0398.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0403.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0405.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0409.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0410.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0414.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0423.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0422.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0424.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0427.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0428.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0429.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0430.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0431.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0434.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0437.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0440.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0441.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0442.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0444.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0445.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0446.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0447.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0448.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0449.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0453.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0459.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0460.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0461.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0462.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0463.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0464.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0465.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});
        this.arr.push({src:"web_0467.jpg",orientation:0,alt:"",category : this.categories.HM_OWL.id});

        //westport beach
        this.arr.push({src:"web_0468.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0254.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0255.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0470.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0472.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0473.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0475.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0476.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0477.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0478.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0479.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0481.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0483.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0486.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0487.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0489.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0490.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0491.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0493.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0494.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0495.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0496.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0497.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0498.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0500.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0502.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0505.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0506.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0507.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0508.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0512.jpg",orientation:1,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0515.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0516.jpg",orientation:1,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0522.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0523.jpg",orientation:1,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0526.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0528.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0529.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0530.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0531.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0532.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0534.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0538.jpg",orientation:1,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0542.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0544.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0545.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0546.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0558.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0559.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0560.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0561.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0562.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0563.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0564.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0565.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0566.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0567.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0570.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0577.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0578.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0579.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0580.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0581.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0582.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0583.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0584.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0585.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0586.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0587.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0589.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0590.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0592.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0593.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0595.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0596.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0597.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});
        this.arr.push({src:"web_0599.jpg",orientation:0,alt:"",category : this.categories.HM_WESTPORT.id});


        this.arr.push({src:"web_0070.jpg",orientation:0,alt:"",category : this.categories.TEST.id});
        this.arr.push({src:"web_0072.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0073.jpg",orientation:0,alt:"",category : this.categories.TEST.id});
        this.arr.push({src:"web_0074.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0083.jpg",orientation:0,alt:"",category : this.categories.TEST.id});
        this.arr.push({src:"web_0085.jpg",orientation:0,alt:"",category : this.categories.TEST.id});
        this.arr.push({src:"web_0087.jpg",orientation:0,alt:"",category : this.categories.TEST.id});
        this.arr.push({src:"web_0088.jpg",orientation:0,alt:"",category : this.categories.TEST.id});
        this.arr.push({src:"web_0089.jpg",orientation:0,alt:"",category : this.categories.TEST.id});
        this.arr.push({src:"web_0090.jpg",orientation:1,alt:"",category : this.categories.TEST.id});
        this.arr.push({src:"web_0091.jpg",orientation:1,alt:"",category : this.categories.TEST.id});

        this.arr.push({src:"web_0096.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0097.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0098.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0126.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0127.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0128.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0129.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0130.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0132.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0133.jpg",orientation:1,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0134.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0135.jpg",orientation:1,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0136.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0137.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0139.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0144.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0243.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0244.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0245.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0246.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0250.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0258.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0259.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id})
        ;
        this.arr.push({src:"web_0260.jpg",orientation:0,alt:"",category : this.categories.TEST.id});
        this.arr.push({src:"web_0275.jpg",orientation:1,alt:"",category : this.categories.TEST.id});


        this.arr.push({src:"web_0290.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0291.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0292.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0294.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0295.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0302.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0303.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0304.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0305.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0306.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0311.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0313.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0331.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0337.jpg",orientation:1,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0338.jpg",orientation:1,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0339.jpg",orientation:1,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0340.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0341.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0342.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0343.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0349.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0351.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0360.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});


        this.arr.push({src:"web_0361.jpg",orientation:0,alt:"",category : this.categories.TEST.id});
        this.arr.push({src:"web_0365.jpg",orientation:0,alt:"",category : this.categories.TEST.id});

        this.arr.push({src:"web_0547.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0556.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0557.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0600.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0602.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0603.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0604.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0605.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0607.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0608.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0609.jpg",orientation:1,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0611.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});
        this.arr.push({src:"web_0612.jpg",orientation:0,alt:"",category : this.categories.HM_OTHER.id});


        this.arr.push({src:"web_0613.jpg",orientation:1,alt:"",category : this.categories.HM_GDNS.id});
        this.arr.push({src:"web_0616.jpg",orientation:1,alt:"",category : this.categories.HM_GDNS.id});
        this.arr.push({src:"web_0618.jpg",orientation:0,alt:"",category : this.categories.HM_GDNS.id});
        this.arr.push({src:"web_0619.jpg",orientation:0,alt:"",category : this.categories.HM_GDNS.id});
        this.arr.push({src:"web_0620.jpg",orientation:0,alt:"",category : this.categories.HM_GDNS.id});
        this.arr.push({src:"web_0621.jpg",orientation:0,alt:"",category : this.categories.HM_GDNS.id});
        this.arr.push({src:"web_0622.jpg",orientation:1,alt:"",category : this.categories.HM_GDNS.id});
        this.arr.push({src:"web_0625.jpg",orientation:1,alt:"",category : this.categories.HM_GDNS.id});
        this.arr.push({src:"web_0626.jpg",orientation:1,alt:"",category : this.categories.HM_GDNS.id});
        this.arr.push({src:"web_0628.jpg",orientation:1,alt:"",category : this.categories.HM_GDNS.id});
        this.arr.push({src:"web_0629.jpg",orientation:0,alt:"",category : this.categories.HM_GDNS.id});
        this.arr.push({src:"web_0630.jpg",orientation:0,alt:"",category : this.categories.HM_GDNS.id});
        this.arr.push({src:"web_0633.jpg",orientation:1,alt:"",category : this.categories.HM_GDNS.id});
        this.arr.push({src:"web_0634.jpg",orientation:0,alt:"",category : this.categories.HM_GDNS.id});
        this.arr.push({src:"web_0635.jpg",orientation:0,alt:"",category : this.categories.HM_GDNS.id});
        this.arr.push({src:"web_0636.jpg",orientation:1,alt:"",category : this.categories.HM_GDNS.id});
        this.arr.push({src:"web_0638.jpg",orientation:1,alt:"",category : this.categories.HM_GDNS.id});
        this.arr.push({src:"web_0639.jpg",orientation:0,alt:"",category : this.categories.HM_GDNS.id});
        this.arr.push({src:"web_0641.jpg",orientation:0,alt:"",category : this.categories.HM_GDNS.id});
        this.arr.push({src:"web_0642.jpg",orientation:1,alt:"",category : this.categories.HM_GDNS.id});
        this.arr.push({src:"web_0643.jpg",orientation:0,alt:"",category : this.categories.HM_GDNS.id});
        this.arr.push({src:"web_0644.jpg",orientation:0,alt:"",category : this.categories.HM_GDNS.id});
        this.arr.push({src:"web_0645.jpg",orientation:0,alt:"",category : this.categories.HM_GDNS.id});
        this.arr.push({src:"web_0646.jpg",orientation:0,alt:"",category : this.categories.HM_GDNS.id});
        this.arr.push({src:"web_0647.jpg",orientation:0,alt:"",category : this.categories.HM_GDNS.id});
        this.arr.push({src:"web_0649.jpg",orientation:0,alt:"",category : this.categories.HM_GDNS.id});
        this.arr.push({src:"web_0651.jpg",orientation:0,alt:"",category : this.categories.HM_GDNS.id});
        this.arr.push({src:"web_0653.jpg",orientation:0,alt:"",category : this.categories.HM_GDNS.id});
        this.arr.push({src:"web_0655.jpg",orientation:0,alt:"",category : this.categories.HM_GDNS.id});
        this.arr.push({src:"web_0656.jpg",orientation:0,alt:"",category : this.categories.HM_GDNS.id});
        this.arr.push({src:"web_0657.jpg",orientation:0,alt:"",category : this.categories.HM_GDNS.id});
        
        var allImagesLoaded = false;
        //and prefix the URL with path:
        for(var a=0;a<this.arr.length;a++){
            
            this.arr[a].src = this.IMGPATH + this.arr[a].src;
            this.arr[a].category = this.arr[a].category + "";   //because the attr I compare with is a string now
            
            //load an Image() object for each:
            this.arr[a].img = new Image();
            
            

            function loaded() {
                console.log('loaded '+a);
            }

            if (this.arr[a].img.complete) {
                loaded();
            } else {
                this.arr[a].img.addEventListener('load', loaded);
                this.arr[a].img.addEventListener('error', function() {
                    console.log('error');
                });
            }
            
            
            
            this.arr[a].img.src = this.arr[a].src;
        }  
    },

    /*
     * build the flow container in the body area:
     * 
     * <div class="globalCaption"></div>
            <div class="scrollbar"><div class="slider"><div class="position"></div></div></div>
     * 
     */
    buildFlowContainer : function(DOMImageList){

        //remove prior contentflow
        $("#" + this.ContentFlowConfig.displaytargetId).empty();
        
        var ContentFlowContainer = document.createElement("div");
        ContentFlowContainer.setAttribute("id","contentFlow");
        //ContentFlowContainer.setAttribute("class","ContentFlow"); //don't need this if loaded programmatically
        
        //load indicator
        var loadIndicator = document.createElement("div");
        loadIndicator.setAttribute("class","loadIndicator");
        
        var indicator = document.createElement("div");
        indicator.setAttribute("class","indicator");
        loadIndicator.appendChild(indicator);
        
        //scrollbar:
        var scrollbar = document.createElement("div");
        scrollbar.setAttribute("class","scrollbar");
        
        //slider
        var slider = document.createElement("div");
        slider.setAttribute("class","slider");
        scrollbar.appendChild(slider);        
        
        //caption container
        var globalCaption = document.createElement("div");
        globalCaption.setAttribute("class","globalCaption");
        
        //Item container:
        var flow = document.createElement("div");
        flow.setAttribute("class","flow");
        
        //and assemble:
        ContentFlowContainer.appendChild(loadIndicator);
        
        //and push the items onto the flow element:
        for(var a=0;a<DOMImageList.length;a++){
            flow.appendChild(DOMImageList[a]);
        }        
        
        ContentFlowContainer.appendChild(flow);
        ContentFlowContainer.appendChild(globalCaption);
        ContentFlowContainer.appendChild(scrollbar);

        $("#" + this.ContentFlowConfig.displaytargetId).append(ContentFlowContainer);
        $("#" + this.ContentFlowConfig.displaytargetId).load(function(){
            console.log("LOAD CONTENTFLOW FROM LOAD FUNCTION");
        });
    },
    
    //clear out the flow container:
    clearFlowContainer : function(){
        $("#" + this.ContentFlowConfig.displaytargetId).empty();
    },

    //currently TEST:
    buildFlowLinks : function(){
        
        var _outer = document.createElement("select");
        _outer.setAttribute("id","image_display_trigger");
        for(var p in this.categories){
            
            var x = document.createElement("option");
            x.setAttribute("data-image-category",this.categories[p].id);
            x.appendChild(document.createTextNode(this.categories[p].name));  //append thumbnail here? and tile?
            _outer.appendChild(x);
        }
        
        var btn = document.createElement("input");
        btn.setAttribute("type","button");
        btn.setAttribute("value","OK");
        $(btn).click(function(){
            
            //initialise content flow with specified flags:
            if(weddingfest07.ContentFlowConfig.loadContentFlow){

                //build DOM structure:
                weddingfest07.buildFlowContainer(weddingfest07.loadImagesForContentFlow($("#image_display_trigger option:selected").attr("data-image-category")));

                /*
                 * And initialise the contentflow:
                 */
                //console.log("INIT CONTENTFLOW FROM buildFowLinks()");
                var conf = {
                    "onclickActiveItem":weddingfest07.contentFlowItemClickHandler,
                    "circularFlow":true,
                    "visibleItems":3
                };
                var myNewFlow = new ContentFlow("contentFlow",conf);
                
                myNewFlow.init();
            };
        });
        

        $("#" + this.ContentFlowConfig.linksTargetId).append($(_outer));
        $("#" + this.ContentFlowConfig.linksTargetId).append($(btn));
    },

    /*
     * Build overlay for selected image:
     * @returns {undefined}
     */
    contentFlowItemClickHandler : function(){
        var src = $(this.getActiveItem().canvas).attr("src");
        console.log(src);
        
        var _img = new Image();
        _img.src = src;
        
        //trigger featherlight:
        var _config = {};
        $.featherlight($(_img), _config);
        
    },

    /*
     * New method
     * returns an array of DOM elements to append to contentflow instance
     */
    loadImagesForContentFlow : function(categoryFlag){
        
        //get raw data using existing function:
        var _temp = this.getTempArr(categoryFlag);
        var _out = [];

        for(var a=0;a<_temp.length;a++){
            
            //build DOM structure for content flow items to append:
            var item = document.createElement("div");
            item.setAttribute("class","item");
            var img = document.createElement("img");
            
            //img.setAttribute("src",_temp[a].src);
            img.setAttribute("src",_temp[a].img.src);
            img.setAttribute("class","content");
            var caption = document.createElement("div");
            caption.setAttribute("class","caption");
            caption.appendChild(document.createTextNode(_temp[a].alt));
            item.appendChild(img);
            item.appendChild(caption);
            
            //console.log(item.outerHTML);
            
            _out.push(item);
        }

        return _out;
    },


    /**
     * I need to build the temp array so the pagination works correctly!
     * 
     * This method opens a new window with the specified document, and 
     * consructs URL parameters as passed as method arguments.
     * 
     * The method name is strictly not quite correct as it doesn't actually 
     * display the image, it merely opens the popup window. The actual display
     * calls are from the HTML used to populate the window. (displayImageTag(),
     * prevImage() and nextImage(). Each of these uses the passed URL params to
     * display or paginate.        
     * */
    showImage : function(id,category){
        try
        {
            //determine orientation:
            var location = window.location.toString();
            var width   = 680;
            var height  = 550;

            var src = "/weddingfest07/popup.htm?img=" + id + "&category=" + category;
            var w = window.open(src,"gallery","left=20,top=20,width=" + width + ",height=" + height + ",toolbar=0,resizable=0");
            w.focus();
        }

        catch(e)
        {
            alert("Error in method showImage(): "+e.message);
        }
    },

    //return a sub array:
    getTempArr : function (category){
        try
        {
            var tempArr = new Array();
            for(var a=1;a<this.arr.length;a++)
            {
                //check for image category : this.
                if(category === this.arr[a].category)// || category === this.categories.ALL_IMAGES)
                {
                    tempArr.push(this.arr[a]);
                }
            }
            return(tempArr);
        }

        catch(e)
        {
            console.log(e);
            return(false);
        }
    }
};







