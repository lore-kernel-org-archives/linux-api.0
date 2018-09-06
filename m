From: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Subject: Re: [PATCH 08/11] UAPI: sound: Fix use of u32 and co.
	in UAPI headers
Date: Thu, 6 Sep 2018 14:59:40 +0900
Message-ID: <ce6ac597-751c-8881-160d-28d62a898a3e@sakamocchi.jp>
References: <153616286704.23468.584491117180383924.stgit@warthog.procyon.org.uk>
 <153616293089.23468.13515059526628668970.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <alsa-devel-bounces@alsa-project.org>
In-Reply-To: <153616293089.23468.13515059526628668970.stgit@warthog.procyon.org.uk>
Content-Language: en-US
List-Unsubscribe: <http://mailman.alsa-project.org/mailman/options/alsa-devel>,
 <mailto:alsa-devel-request@alsa-project.org?subject=unsubscribe>
List-Archive: <http://mailman.alsa-project.org/pipermail/alsa-devel/>
List-Post: <mailto:alsa-devel@alsa-project.org>
List-Help: <mailto:alsa-devel-request@alsa-project.org?subject=help>
List-Subscribe: <http://mailman.alsa-project.org/mailman/listinfo/alsa-devel>,
 <mailto:alsa-devel-request@alsa-project.org?subject=subscribe>
Errors-To: alsa-devel-bounces@alsa-project.org
Sender: alsa-devel-bounces@alsa-project.org
To: David Howells <dhowells@redhat.com>, linux-api@vger.kernel.org, linux-kbuild@vger.kernel.org
Cc: moderated for non-subscribers <alsa-devel@alsa-project.org>, linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.com>
List-Id: linux-api@vger.kernel.org

Hi,

On Sep 6 2018 00:55, David Howells wrote:
> Fix the use of u32 and co. in UAPI headers as these are not defined.  Switch
> to using the __u32-style equivalents instead.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Jaroslav Kysela <perex@perex.cz>
> cc: Takashi Iwai <tiwai@suse.com>
> cc: alsa-devel@alsa-project.org (moderated for non-subscribers)
> ---
> 
>   include/uapi/sound/skl-tplg-interface.h |  106 ++++++++++++++++---------------
>   1 file changed, 54 insertions(+), 52 deletions(-)

A similar patch was already proposed[1] and has been applied by Mark to
his tree[2]. Your issue (3) is going to be solved soon for v4.19
kernel.

[1] [alsa-devel] [PATCH] uapi: fix sound/skl-tplg-interface.h userspace 
compilation errors
http://mailman.alsa-project.org/pipermail/alsa-devel/2018-August/139392.html
[2] ASoC: uapi: fix sound/skl-tplg-interface.h userspace compilation errors
https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git/log/?h=for-4.19


Thanks

Takashi Sakamoto
