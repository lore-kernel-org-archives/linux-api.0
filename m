From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] ALSA: Adjust structure(snd_timer_tread)
 members to avoid 8 padding bytes
Date: Tue, 30 May 2017 08:26:01 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1705300824480.1950@nanos>
References: <CGME20170530062242epcas5p1fb7f94e02c6550a60603ce28090cc70d@epcas5p1.samsung.com>
 <1496125148-37895-1-git-send-email-manjeet.p@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <alsa-devel-bounces@alsa-project.org>
In-Reply-To: <1496125148-37895-1-git-send-email-manjeet.p@samsung.com>
List-Unsubscribe: <http://mailman.alsa-project.org/mailman/options/alsa-devel>,
 <mailto:alsa-devel-request@alsa-project.org?subject=unsubscribe>
List-Archive: <http://mailman.alsa-project.org/pipermail/alsa-devel/>
List-Post: <mailto:alsa-devel@alsa-project.org>
List-Help: <mailto:alsa-devel-request@alsa-project.org?subject=help>
List-Subscribe: <http://mailman.alsa-project.org/mailman/listinfo/alsa-devel>,
 <mailto:alsa-devel-request@alsa-project.org?subject=subscribe>
Errors-To: alsa-devel-bounces@alsa-project.org
Sender: alsa-devel-bounces@alsa-project.org
To: Manjeet Pawar <manjeet.p@samsung.com>
Cc: Vaneet Narang <v.narang@samsung.com>, alsa-devel@alsa-project.org, a.sahrawat@samsung.com, tiwai@suse.de, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, lalit.mohan@samsung.com, pankaj.m@samsung.com
List-Id: linux-api@vger.kernel.org

On Tue, 30 May 2017, Manjeet Pawar wrote:
> This patch is made to fix below CVE issue where 8 padding bytes are sent to
> user without being initialized. Structure members are adjusted to avoid 8 
> padding bytes.
> 
> CVE-2016-4569/CVE-2016-4578:
> The stack object tread has a total size of 32 bytes. Its field
> event and val both contain 4 bytes padding. These 8 bytes
> padding bytes are sent to user without being initialized.
> 
> Fix patch:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=cec8f96e49d9be372fdb0c3836dcf31ec71e457e
> https://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound.git/commit/?h=for-next&id=9a47e9cff994f37f7f0dbd9ae23740d0f64f9fe6
> 
> These patches does memset on structure object to initialize 8 padding bytes, which can be skipped by 
> adjusting structure members.

And by rearranging the struct members you break existing user space, which
is a NONO. The struct has to stay as is.

Thanks,

	tglx
