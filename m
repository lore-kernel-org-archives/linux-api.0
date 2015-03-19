From: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V6] Allow compaction of unevictable pages
Date: Thu, 19 Mar 2015 11:34:35 -0400
Message-ID: <550AEC8B.1080806@akamai.com>
References: <1426773430-31052-1-git-send-email-emunson@akamai.com> <550AE38E.7090006@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <550AE38E.7090006-AlSwsSmVLrQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-rt-users-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/19/2015 10:56 AM, Vlastimil Babka wrote:
> On 03/19/2015 02:57 PM, Eric B Munson wrote:
>> Currently, pages which are marked as unevictable are protected
>> from compaction, but not from other types of migration.  The
>> POSIX real time extension explicitly states that mlock() will
>> prevent a major page fault, but the spirit of is is that mlock()
>> should give a process the ability to control sources of latency,
>> including minor page faults. However, the mlock manpage only
>> explicitly says that a locked page will not be written to swap
>> and this can cause some confusion.  The compaction code today,
>> does not give a developer who wants to avoid swap but wants to
>> have large contiguous areas available any method to achieve this
>> state.  This patch introduces a sysctl for controlling
>> compaction behavoir with respect to the unevictable lru.  Users
>> that demand no page
> 
> behavior
> 
>> faults after a page is present can set compact_unevictable to 0
>> and
> 
> compact_unevictable_allowed
> 
>> users who need the large contiguous areas can enable compaction
>> on locked memory by leaving the default value of 1.
>> 
>> To illustrate this problem I wrote a quick test program that
>> mmaps a large number of 1MB files filled with random data.  These
>> maps are created locked and read only.  Then every other mmap is
>> unmapped and I attempt to allocate huge pages to the static huge
>> page pool.  When the compact_unevictable sysctl is 0, I cannot
>> allocate hugepages after
> 
> compact_unevictable_allowed
> 
>> fragmenting memory.  When the value is set to 1, allocations
>> succeed.
>> 
>> Signed-off-by: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org> Cc: Vlastimil
>> Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
> 
> Acked-by: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
> 
> Thanks.
> 

Thanks, I have a version with the changelog fixed up to actually make
sense and can submit that if the patch is acceptable otherwise.

Eric

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJVCuyHAAoJELbVsDOpoOa95w0QAIia0yPziiFJRx9uJlGwIfuM
IPHeQ1g201OJiKHxYpZI9FqSu+QJb9UFSPS7ewCH7xE+1aPxEL2pLDZxI5w8OPbY
KYxrVWBdTNesN5Xu8kb0yCXWlk5wGbf65jqMyBJlT9Y+GSiI3zK0AIQgu9Es8zep
YCcig4xfeojzzwGelszsBQ+iDpwqeiS76hCO20yuI5z5G5Le1h7MjxErXZ/uSwlv
+8CHgJWtISjjOYLnbFSEciQmvvcSXtGDmXJ2ru6tgLRoWyIcu3lCyvl/9zi4PuJz
hBtZ5TjQDbyBfj7Vyop90SA9/vwQL8F0wgi9yZXTklebB5cY5b+dWuFdcf14dn2o
uXalxBd1MBQ1hpGXGOLuQCoBows/REjPgKGu+0xGknPL56DXKmoWBeSpjnJKcqIA
bavYJ3bE7HSBI/zjaN2ZiP2Kxl3Y2fV3nmSoXVDJ6hPnYSZUMr1/dBRy5g+kTJ52
wrJt9gMi17alZZFNxsn+EnpagmghwQ89UHLG+ssOViW1DX0j6OxfFDpUlMbso6GS
KW4faaPpIlGbD03f8zZzuCG859rVDiah5WZLVWHG30mVevxvut5QSQo9FEpc2yCk
SG7jghV6Pj3m/F7tdOtwO2PpVSIA0tvxiX734H+z2NoU1Ozfwhofb0hGeEZyp7jm
oAKnxZkkaDbdiaSrNoRM
=bs7n
-----END PGP SIGNATURE-----
