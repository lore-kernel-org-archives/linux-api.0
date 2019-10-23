From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH 2/2] mm, vmstat: List total free blocks for each order in
 /proc/pagetypeinfo
Date: Wed, 23 Oct 2019 14:07:08 -0400
Message-ID: <724cbfa3-2a04-718b-5c98-942a452566f4@redhat.com>
References: <20191023102737.32274-3-mhocko@kernel.org>
 <20191023173423.12532-2-longman@redhat.com>
 <20191023180217.GO17610@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191023180217.GO17610@dhcp22.suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>, Vlastimil Babka <vbabka@suse.cz>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Jann Horn <jannh@google.com>, Song Liu <songliubraving@fb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rafael Aquini <aquini@redhat.com>
List-Id: linux-api@vger.kernel.org

On 10/23/19 2:02 PM, Michal Hocko wrote:
> On Wed 23-10-19 13:34:23, Waiman Long wrote:
> [...]
>> @@ -1419,6 +1419,17 @@ static void pagetypeinfo_showfree_print(struct se=
q_file *m,
>>  =09=09}
>>  =09=09seq_putc(m, '\n');
>>  =09}
>> +
>> +=09/*
>> +=09 * List total free blocks per order
>> +=09 */
>> +=09seq_printf(m, "Node %4d, zone %8s, total             ",
>> +=09=09   pgdat->node_id, zone->name);
>> +=09for (order =3D 0; order < MAX_ORDER; ++order) {
>> +=09=09area =3D &(zone->free_area[order]);
>> +=09=09seq_printf(m, "%6lu ", area->nr_free);
>> +=09}
>> +=09seq_putc(m, '\n');
> This is essentially duplicating /proc/buddyinfo. Do we really need that?

Yes, you are right. As the information is available elsewhere. I am fine
with dropping this.

Cheers,
Longman
