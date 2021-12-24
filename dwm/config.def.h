/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int gappx     = 1;        /* gap pixel between windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 0;        /* 0 means bottom bar */
static const char *fonts[]          = { "DejaVu Sans Mono:size=10" };
static const char dmenufont[]       = "DejaVu Sans Mono:size=10";
static const char col_gray1[]       = "#222222";
static const char col_gray2[]       = "#444444";
static const char col_gray3[]       = "#bbbbbb";
static const char col_gray4[]       = "#eeeeee";
static const char col_cyan[]        = "#005577";
static const char some_blue[]		= "#3F72AF";
static const char *colors[][3]      = {
	/*               fg         bg         border   */
	[SchemeNorm] = { col_gray3, col_gray1, col_gray2 },
	[SchemeSel]  = { col_gray4, col_cyan,  some_blue  },
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "Gimp",     NULL,       NULL,       0,            1,           -1 },
	{ "Firefox",  NULL,       NULL,       1 << 8,       0,           -1 },
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run","-b", "-m", dmenumon, "-fn", dmenufont, "-nb", col_gray1, "-nf", col_gray3, "-sb", col_cyan, "-sf", col_gray4, NULL };
static const char *termcmd[]  = { "st", NULL };
static const char *volUpCmd[] = { "vol_up", NULL};
static const char *volDownCmd[] = { "vol_down", NULL};

static Key keys[] = {
	/* modifier                     key        				function        argument */
	{ MODKEY,                       XK_p,      				spawn,          {.v = dmenucmd } },
	{ ControlMask|Mod1Mask,         XK_t,      				spawn,          {.v = termcmd } },
	{ ControlMask|Mod1Mask,         XK_Up,      			spawn,          {.v = volUpCmd } }, 
	{ ControlMask|Mod1Mask,         XK_Down,      			spawn,          {.v = volDownCmd } },
	{ MODKEY,                       XK_b,      				togglebar,      {0} },
	{ MODKEY,                       XK_Up,     				focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_Down,   				focusstack,     {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_KP_Add,  			incnmaster,     {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_KP_Subtract,      	incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_KP_Subtract,      	setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_KP_Add,      		setmfact,       {.f = +0.05} },
	{ MODKEY,                       XK_Return, 				zoom,           {0} },
	{ MODKEY,                       XK_Tab,    				view,           {0} },
	{ MODKEY,             			XK_q,      				killclient,     {0} },
	{ MODKEY,                       XK_t,      				setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,      				setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,      				setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_space,  				setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  				togglefloating, {0} },
	{ MODKEY,                       XK_0,      				view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      				tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_Left, 				focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_Right,				focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_Left, 				tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_Right,				tagmon,         {.i = +1 } },
	TAGKEYS(                        XK_KP_End,                    0)
	TAGKEYS(                        XK_KP_Down,                   1)
	TAGKEYS(                        XK_KP_Page_Down,              2)
	TAGKEYS(                        XK_KP_Left,                   3)
	TAGKEYS(                        XK_KP_Begin,                  4)
	TAGKEYS(                        XK_KP_Right,                  5)
	TAGKEYS(                        XK_KP_Home,                   6)
	TAGKEYS(                        XK_KP_Up,                     7)
	TAGKEYS(                        XK_KP_Page_Up,                8)
	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

