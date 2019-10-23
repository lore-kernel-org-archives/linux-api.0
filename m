From: Waiman Long <longman@redhat.com>
Subject: [PATCH 1/2] mm, vmstat: Release zone lock more frequently when reading /proc/pagetypeinfo
Date: Wed, 23 Oct 2019 13:34:22 -0400
Message-ID: <20191023173423.12532-1-longman@redhat.com>
References: <20191023102737.32274-3-mhocko@kernel.org>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191023102737.32274-3-mhocko@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Mel Gorman <mgorman@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>, Vlastimil Babka <vbabka@suse.cz>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Jann Horn <jannh@google.com>, Song Liu <songliubraving@fb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rafael Aquini <aquini@redhat.com>, Waiman Long <longman@redhat.com>
List-Id: linux-api@vger.kernel.org

With a threshold of 100000, it is still possible that the zone lock
will be held for a very long time in the worst case scenario where all
the counts are just below the threshold. With up to 6 migration types
and 11 orders, it means up to 6.6 millions.

Track the total number of list iterations done since the acquisition
of the zone lock and release it whenever 100000 iterations or more have
been completed. This will cap the lock hold time to no more than 200,000
list iterations.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 mm/vmstat.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index 57ba091e5460..c5b82fdf54af 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1373,6 +1373,7 @@ static void pagetypeinfo_showfree_print(struct seq_fi=
le *m,
 =09=09=09=09=09pg_data_t *pgdat, struct zone *zone)
 {
 =09int order, mtype;
+=09unsigned long iteration_count =3D 0;
=20
 =09for (mtype =3D 0; mtype < MIGRATE_TYPES; mtype++) {
 =09=09seq_printf(m, "Node %4d, zone %8s, type %12s ",
@@ -1397,15 +1398,24 @@ static void pagetypeinfo_showfree_print(struct seq_=
file *m,
 =09=09=09=09 * of pages in this order should be more than
 =09=09=09=09 * sufficient
 =09=09=09=09 */
-=09=09=09=09if (++freecount >=3D 100000) {
+=09=09=09=09if (++freecount > 100000) {
 =09=09=09=09=09overflow =3D true;
-=09=09=09=09=09spin_unlock_irq(&zone->lock);
-=09=09=09=09=09cond_resched();
-=09=09=09=09=09spin_lock_irq(&zone->lock);
+=09=09=09=09=09freecount--;
 =09=09=09=09=09break;
 =09=09=09=09}
 =09=09=09}
 =09=09=09seq_printf(m, "%s%6lu ", overflow ? ">" : "", freecount);
+=09=09=09/*
+=09=09=09 * Take a break and release the zone lock when
+=09=09=09 * 100000 or more entries have been iterated.
+=09=09=09 */
+=09=09=09iteration_count +=3D freecount;
+=09=09=09if (iteration_count >=3D 100000) {
+=09=09=09=09iteration_count =3D 0;
+=09=09=09=09spin_unlock_irq(&zone->lock);
+=09=09=09=09cond_resched();
+=09=09=09=09spin_lock_irq(&zone->lock);
+=09=09=09}
 =09=09}
 =09=09seq_putc(m, '\n');
 =09}
--=20
2.18.1
