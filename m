From: Waiman Long <longman@redhat.com>
Subject: [PATCH 2/2] mm, vmstat: List total free blocks for each order in /proc/pagetypeinfo
Date: Wed, 23 Oct 2019 13:34:23 -0400
Message-ID: <20191023173423.12532-2-longman@redhat.com>
References: <20191023102737.32274-3-mhocko@kernel.org>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191023102737.32274-3-mhocko@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Mel Gorman <mgorman@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>, Vlastimil Babka <vbabka@suse.cz>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Jann Horn <jannh@google.com>, Song Liu <songliubraving@fb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rafael Aquini <aquini@redhat.com>, Waiman Long <longman@redhat.com>
List-Id: linux-api@vger.kernel.org

Now that the free block count for each migration types in
/proc/pagetypeinfo may not show the exact count if it excceeds
100,000. Users may not know how much more the counts will be. As the
free_area structure has already tracked the total free block count in
nr_free, we may as well print it out with no additional cost. That will
give users a rough idea of where the upper bounds will be.

If there is no overflow, the presence of the total counts will also
enable us to check if the nr_free counts match the total number of
entries in the free lists.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 mm/vmstat.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index c5b82fdf54af..172946d8f358 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1373,6 +1373,7 @@ static void pagetypeinfo_showfree_print(struct seq_fi=
le *m,
 =09=09=09=09=09pg_data_t *pgdat, struct zone *zone)
 {
 =09int order, mtype;
+=09struct free_area *area;
 =09unsigned long iteration_count =3D 0;
=20
 =09for (mtype =3D 0; mtype < MIGRATE_TYPES; mtype++) {
@@ -1382,7 +1383,6 @@ static void pagetypeinfo_showfree_print(struct seq_fi=
le *m,
 =09=09=09=09=09migratetype_names[mtype]);
 =09=09for (order =3D 0; order < MAX_ORDER; ++order) {
 =09=09=09unsigned long freecount =3D 0;
-=09=09=09struct free_area *area;
 =09=09=09struct list_head *curr;
 =09=09=09bool overflow =3D false;
=20
@@ -1419,6 +1419,17 @@ static void pagetypeinfo_showfree_print(struct seq_f=
ile *m,
 =09=09}
 =09=09seq_putc(m, '\n');
 =09}
+
+=09/*
+=09 * List total free blocks per order
+=09 */
+=09seq_printf(m, "Node %4d, zone %8s, total             ",
+=09=09   pgdat->node_id, zone->name);
+=09for (order =3D 0; order < MAX_ORDER; ++order) {
+=09=09area =3D &(zone->free_area[order]);
+=09=09seq_printf(m, "%6lu ", area->nr_free);
+=09}
+=09seq_putc(m, '\n');
 }
=20
 /* Print out the free pages at each order for each migatetype */
--=20
2.18.1
