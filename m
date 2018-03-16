From: Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH ghau40 v2 4/5] add ausearch containerid support
Date: Fri, 16 Mar 2018 05:12:28 -0400
Message-ID: <1521191549-19764-5-git-send-email-rgb@redhat.com>
References: <1521191549-19764-1-git-send-email-rgb@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1521191549-19764-1-git-send-email-rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Cc: luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, viro@zeniv.linux.org.uk, dhowells@redhat.com, simo@redhat.com, eparis@parisplace.org, serge@hallyn.com, ebiederm@xmission.com, madzcar@gmail.com, Richard Guy Briggs <rgb@redhat.com>
List-Id: linux-api@vger.kernel.org

Add support to ausearch for searching on the containerid field in
records.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 src/aureport-options.c |   1 +
 src/ausearch-llist.c   |   2 +
 src/ausearch-llist.h   |   1 +
 src/ausearch-match.c   |   3 +
 src/ausearch-options.c |  46 ++++++++++++-
 src/ausearch-options.h |   1 +
 src/ausearch-parse.c   | 171 +++++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 224 insertions(+), 1 deletion(-)

diff --git a/src/aureport-options.c b/src/aureport-options.c
index 9b914ed..ffff436 100644
--- a/src/aureport-options.c
+++ b/src/aureport-options.c
@@ -62,6 +62,7 @@ const char *event_vmname = NULL;
 long long event_exit = 0;
 int event_exit_is_set = 0;
 int event_ppid = -1, event_session_id = -2;
+unsigned long long int event_container_id = -2;
 int event_debug = 0, event_machine = -1;
 
 /* These are used by aureport */
diff --git a/src/ausearch-llist.c b/src/ausearch-llist.c
index ef5503c..c910724 100644
--- a/src/ausearch-llist.c
+++ b/src/ausearch-llist.c
@@ -60,6 +60,7 @@ void list_create(llist *l)
 	l->s.arch = 0;
 	l->s.syscall = 0;
 	l->s.session_id = -2;
+	l->s.container_id = -2;
 	l->s.uuid = NULL;
 	l->s.vmname = NULL;
 	l->s.tuid = NULL;
@@ -211,6 +212,7 @@ void list_clear(llist* l)
 	l->s.arch = 0;
 	l->s.syscall = 0;
 	l->s.session_id = -2;
+	l->s.container_id = -2;
 	free(l->s.uuid);
 	l->s.uuid = NULL;
 	free(l->s.vmname);
diff --git a/src/ausearch-llist.h b/src/ausearch-llist.h
index 64e4ee1..1c651c5 100644
--- a/src/ausearch-llist.h
+++ b/src/ausearch-llist.h
@@ -56,6 +56,7 @@ typedef struct
   int arch;             // arch
   int syscall;          // syscall
   uint32_t session_id;  // Login session id
+  __u64 container_id;// Container id
   long long exit;       // Syscall exit code
   int exit_is_set;      // Syscall exit code is valid
   char *hostname;       // remote hostname
diff --git a/src/ausearch-match.c b/src/ausearch-match.c
index 61a11d3..51dccb0 100644
--- a/src/ausearch-match.c
+++ b/src/ausearch-match.c
@@ -113,6 +113,9 @@ int match(llist *l)
 				if ((event_session_id != -2) &&
 					(event_session_id != l->s.session_id))
 					return 0;
+				if ((event_container_id != -2) &&
+					(event_container_id != l->s.container_id))
+					return 0;
 				if (event_exit_is_set) {
 					if (l->s.exit_is_set == 0)
 						return 0;
diff --git a/src/ausearch-options.c b/src/ausearch-options.c
index a3f08e7..1d095a7 100644
--- a/src/ausearch-options.c
+++ b/src/ausearch-options.c
@@ -60,6 +60,7 @@ int event_syscall = -1, event_machine = -1;
 int event_ua = 0, event_ga = 0, event_se = 0;
 int just_one = 0;
 uint32_t event_session_id = -2;
+unsigned long long int event_container_id = -2;
 long long event_exit = 0;
 int event_exit_is_set = 0;
 int line_buffered = 0;
@@ -88,7 +89,7 @@ struct nv_pair {
 
 enum { S_EVENT, S_COMM, S_FILENAME, S_ALL_GID, S_EFF_GID, S_GID, S_HELP,
 S_HOSTNAME, S_INTERP, S_INFILE, S_MESSAGE_TYPE, S_PID, S_SYSCALL, S_OSUCCESS,
-S_TIME_END, S_TIME_START, S_TERMINAL, S_ALL_UID, S_EFF_UID, S_UID, S_LOGINID,
+S_TIME_END, S_TIME_START, S_TERMINAL, S_ALL_UID, S_EFF_UID, S_UID, S_LOGINID, S_CONTAINERID,
 S_VERSION, S_EXACT_MATCH, S_EXECUTABLE, S_CONTEXT, S_SUBJECT, S_OBJECT,
 S_PPID, S_KEY, S_RAW, S_NODE, S_IN_LOGS, S_JUST_ONE, S_SESSION, S_EXIT,
 S_LINEBUFFERED, S_UUID, S_VMNAME, S_DEBUG, S_CHECKPOINT, S_ARCH, S_FORMAT,
@@ -169,6 +170,7 @@ static struct nv_pair optiontab[] = {
 	{ S_UUID, "--uuid" },
 	{ S_LOGINID, "-ul" },
 	{ S_LOGINID, "--loginuid" },
+	{ S_CONTAINERID, "--containerid" },
 	{ S_VERSION, "-v" },
 	{ S_VERSION, "--version" },
 	{ S_VMNAME, "-vm" },
@@ -1182,6 +1184,48 @@ int check_params(int count, char *vars[])
 			}
 			c++;
 			break;
+		case S_CONTAINERID:
+			if (!optarg) {
+				if ((c+1 < count) && vars[c+1])
+					optarg = vars[c+1];
+				else {
+					fprintf(stderr,
+						"Argument is required for %s\n",
+						vars[c]);
+					retval = -1;
+					break;
+				}
+			}
+			{
+			size_t len = strlen(optarg);
+			if (isdigit(optarg[0])) {
+				errno = 0;
+				event_container_id = strtoull(optarg,NULL,0);
+				if (errno) {
+					fprintf(stderr, 
+			"Numeric container ID conversion error (%s) for %s\n",
+						strerror(errno), optarg);
+					retval = -1;
+				}
+			} else if (len >= 2 && *(optarg)=='-' &&
+					(isdigit(optarg[1]))) {
+				errno = 0;
+				event_container_id = strtoll(optarg, NULL, 0);
+				if (errno) {
+					retval = -1;
+					fprintf(stderr, "Error converting %s\n",
+						optarg);
+				}
+			} else {
+				fprintf(stderr, 
+			"Container ID is non-numeric and unknown (%s)\n",
+						optarg);
+				retval = -1;
+				break;
+			}
+			}
+			c++;
+			break;
 		case S_UUID:
 			if (!optarg) {
 				fprintf(stderr,
diff --git a/src/ausearch-options.h b/src/ausearch-options.h
index 1372762..b7830a1 100644
--- a/src/ausearch-options.h
+++ b/src/ausearch-options.h
@@ -40,6 +40,7 @@ extern int line_buffered;
 extern int event_debug;
 extern pid_t event_ppid;
 extern uint32_t event_session_id;
+extern unsigned long long int event_container_id;
 extern ilist *event_type;
 
 /* Data type to govern output format */
diff --git a/src/ausearch-parse.c b/src/ausearch-parse.c
index 07bad89..b9b49c4 100644
--- a/src/ausearch-parse.c
+++ b/src/ausearch-parse.c
@@ -52,6 +52,8 @@ static int parse_path(const lnode *n, search_items *s);
 static int parse_user(const lnode *n, search_items *s);
 static int parse_obj(const lnode *n, search_items *s);
 static int parse_login(const lnode *n, search_items *s);
+static int parse_container(const lnode *n, search_items *s);
+static int parse_container_info(const lnode *n, search_items *s);
 static int parse_daemon1(const lnode *n, search_items *s);
 static int parse_daemon2(const lnode *n, search_items *s);
 static int parse_sockaddr(const lnode *n, search_items *s);
@@ -112,6 +114,9 @@ int extract_search_items(llist *l)
 			case AUDIT_LOGIN:
 				ret = parse_login(n, s);
 				break;
+			case AUDIT_CONTAINER:
+				ret = parse_container(n, s);
+				break;
 			case AUDIT_IPC:
 			case AUDIT_OBJ_PID:
 				ret = parse_obj(n, s);
@@ -177,6 +182,9 @@ int extract_search_items(llist *l)
 			case AUDIT_TTY:
 				ret = parse_tty(n, s);
 				break;
+			case AUDIT_CONTAINER_INFO:
+				ret = parse_container_info(n, s);
+				break;
 			default:
 				if (event_debug)
 					fprintf(stderr,
@@ -1379,6 +1387,169 @@ static int parse_login(const lnode *n, search_items *s)
 	return 0;
 }
 
+static int parse_container(const lnode *n, search_items *s)
+{
+	char *ptr, *str, *term = n->message;
+
+	// skip op
+	// get pid
+	if (event_pid != -1) {
+		str = strstr(term, "pid=");
+		if (str == NULL)
+			return 1;
+		ptr = str + 4;
+		term = strchr(ptr, ' ');
+		if (term == NULL)
+			return 2;
+		*term = 0;
+		errno = 0;
+		s->pid = strtoul(ptr, NULL, 10);
+		if (errno)
+			return 3;
+		*term = ' ';
+	}
+	// get uid
+	if (event_uid != -1 || event_tuid) {
+		str = strstr(term, "uid=");
+		if (str == NULL)
+			return 4;
+		ptr = str + 4;
+		term = strchr(ptr, ' ');
+		if (term == NULL)
+			return 5;
+		*term = 0;
+		errno = 0;
+		s->uid = strtoul(ptr, NULL, 10);
+		if (errno)
+			return 6;
+		*term = ' ';
+		s->tuid = lookup_uid("uid", s->uid);
+	}
+	// get subj
+	if (event_subject) {
+		str = strstr(term, "subj=");
+		if (str) {
+			ptr = str + 5;
+			term = strchr(ptr, ' ');
+			if (term == NULL)
+				return 12;
+			*term = 0;
+			if (audit_avc_init(s) == 0) {
+				anode an;
+
+				anode_init(&an);
+				an.scontext = strdup(str);
+				alist_append(s->avc, &an);
+				*term = ' ';
+			} else
+				return 13;
+			*term = ' ';
+		}
+	}
+	// get loginuid
+	if (event_loginuid != -2 || event_tauid) {
+		str = strstr(term, "auid=");
+		if (str == NULL) {
+			return 7;
+		} else
+			ptr = str + 5;
+		term = strchr(ptr, ' ');
+		if (term)
+			*term = 0;
+		errno = 0;
+		s->loginuid = strtoul(ptr, NULL, 10);
+		if (errno)
+			return 8;
+		if (term)
+			*term = ' ';
+		s->tauid = lookup_uid("auid", s->loginuid);
+	}
+	// skip tty
+	// ses
+	if (event_session_id != -2 ) {
+		if (term == NULL)
+			term = n->message;
+		str = strstr(term, "ses=");
+		if (str == NULL)
+			return 14;
+		else
+			ptr = str + 4;
+		term = strchr(ptr, ' ');
+		if (term)
+			*term = 0;
+		errno = 0;
+		s->session_id = strtoul(ptr, NULL, 10);
+		if (errno)
+			return 11;
+		if (term)
+			*term = ' ';
+	}
+	// skip opid
+	// skip old-contid
+	// get containerid
+	if (event_container_id != -2) {
+		str = strstr(term, "contid=");
+		if (str == NULL) {
+			return 7;
+		} else
+			ptr = str + 7;
+		term = strchr(ptr, ' ');
+		if (term)
+			*term = 0;
+		errno = 0;
+		s->container_id = strtoull(ptr, NULL, 10);
+		if (errno)
+			return 8;
+		if (term)
+			*term = ' ';
+	}
+	// success
+	if (event_success != S_UNSET) {
+		if (term == NULL)
+			term = n->message;
+		str = strstr(term, "res=");
+		if (str != NULL) {
+			ptr = str + 4;
+			term = strchr(ptr, ' ');
+			if (term)
+				*term = 0;
+			errno = 0;
+			s->success = strtoul(ptr, NULL, 10);
+			if (errno)
+				return 9;
+			if (term)
+				*term = ' ';
+		} else
+			return 7;
+	}
+	return 0;
+}
+
+static int parse_container_info(const lnode *n, search_items *s)
+{
+	char *ptr, *str, *term = n->message;
+
+	// skip op
+	// get containerid
+	if (event_container_id != -2) {
+		str = strstr(term, "contid=");
+		if (str == NULL) {
+			return 7;
+		} else
+			ptr = str + 7;
+		term = strchr(ptr, ' ');
+		if (term)
+			*term = 0;
+		errno = 0;
+		s->container_id = strtoull(ptr, NULL, 10);
+		if (errno)
+			return 8;
+		if (term)
+			*term = ' ';
+	}
+	return 0;
+}
+
 static int parse_daemon1(const lnode *n, search_items *s)
 {
 	char *ptr, *str, *term, saved, *mptr;
-- 
1.8.3.1
