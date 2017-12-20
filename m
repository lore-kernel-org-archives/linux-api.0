From: "Dr. Manfred Spraul" <manfred-nhLOkwUX5cPe2c5cEj3t2g@public.gmane.org>
Subject: Re: shmctl(SHM_STAT) vs. /proc/sysvipc/shm permissions discrepancies
Date: Wed, 20 Dec 2017 09:32:01 +0100
Message-ID: <f8745470-b4fb-97ef-d6ab-40b437be181c@colorfullife.com>
References: <20171219094848.GE2787@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171219094848.GE2787-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Michal,

On 12/19/2017 10:48 AM, Michal Hocko wrote:
> Hi,
> we have been contacted by our partner about the following permission
> discrepancy
> 1. Create a shared memory segment with permissions 600 with user A using
>     shmget(key, 1024, 0600 | IPC_CREAT)
> 2. ipcs -m should return an output as follows:
>
> ------ Shared Memory Segments --------
> key        shmid      owner      perms      bytes      nattch     status
> 0x58b74326 759562241  A          600        1024       0
>
> 3. Try to read the metadata with shmctl(0, SHM_STAT,...) as user B.
> 4. shmctl will return -EACCES
>
> The supper set information provided by shmctl can be retrieved by
> reading /proc/sysvipc/shm which does not require read permissions
> because it is 444.
>
> It seems that the discrepancy is there since ae7817745eef ("[PATCH] ipc:
> add generic struct ipc_ids seq_file iteration") when the proc interface
> has been introduced. The changelog is really modest on information or
> intention but I suspect this just got overlooked during review. SHM_STAT
> has always been about read permission and it is explicitly documented
> that way.
Are you sure that this patch changed the behavior?
The proc interface is much older.

--
     Manfred
