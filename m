From: Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH -mm v9 0/8] idle memory tracking
Date: Wed, 29 Jul 2015 08:08:22 -0700
Message-ID: <CANN689Euq3Y-CHQo8q88vzFAYZX4S6rK+rZRfbuSKfS74u=gcg@mail.gmail.com>
References: <cover.1437303956.git.vdavydov@parallels.com>
	<20150729123629.GI15801@dhcp22.suse.cz>
	<20150729135907.GT8100@esperanza>
	<CANN689HJX2ZL891uOd8TW9ct4PNH9d5odQZm86WMxkpkCWhA-w@mail.gmail.com>
	<20150729144539.GU8100@esperanza>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary=001a11398bee328a01051c04f509
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20150729144539.GU8100@esperanza>
Sender: owner-linux-mm@kvack.org
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Andres Lagar-Cavilla <andreslc@google.com>, Minchan Kim <minchan@kernel.org>, Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>, Johannes Weiner <hannes@cmpxchg.org>, Greg Thelen <gthelen@google.com>, David Rientjes <rientjes@google.com>, Pavel Emelyanov <xemul@parallels.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Jonathan Corbet <corbet@lwn.net>, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

--001a11398bee328a01051c04f509
Content-Type: text/plain; charset=UTF-8

On Wed, Jul 29, 2015 at 7:45 AM, Vladimir Davydov <vdavydov@parallels.com>
wrote:
> Page table scan approach has the inherent problem - it ignores unmapped
> page cache. If a workload does a lot of read/write or map-access-unmap
> operations, we won't be able to even roughly estimate its wss.

You can catch that in mark_page_accessed on those paths, though.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.

--001a11398bee328a01051c04f509
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 29, 2015 at 7:45 AM, Vladimir Davydov &lt;<a href=3D"mailto:vda=
vydov@parallels.com">vdavydov@parallels.com</a>&gt; wrote:<br>&gt; Page tab=
le scan approach has the inherent problem - it ignores unmapped<br>&gt; pag=
e cache. If a workload does a lot of read/write or map-access-unmap<br>&gt;=
 operations, we won&#39;t be able to even roughly estimate its wss.<br><br>=
You can catch that in mark_page_accessed on those paths, though.<br><br>-- =
<br>Michel &quot;Walken&quot; Lespinasse<br>A program is never fully debugg=
ed until the last user dies.<br>

--001a11398bee328a01051c04f509--

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
