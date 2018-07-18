From: Paul Moore <paul@paul-moore.com>
Subject: Re: [RFC PATCH ghak90 (was ghak32) V3 10/10] rfkill: fix spelling
 mistake contidion to condition
Date: Wed, 18 Jul 2018 16:56:56 -0400
Message-ID: <CAHC9VhROqEZBq6BEoWFtWuVSNyZ4AtewMM2GDmJNaKdfVbcmzw@mail.gmail.com>
References: <cover.1528304203.git.rgb@redhat.com> <6118147ea27ab5831956cf9dcad15b241c791420.1528304204.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <6118147ea27ab5831956cf9dcad15b241c791420.1528304204.git.rgb@redhat.com>
Sender: netdev-owner@vger.kernel.org
To: rgb@redhat.com
Cc: cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, ebiederm@xmission.com, luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, dhowells@redhat.com, viro@zeniv.linux.org.uk, simo@redhat.com, Eric Paris <eparis@parisplace.org>, serge@hallyn.com
List-Id: linux-api@vger.kernel.org

On Wed, Jun 6, 2018 at 1:02 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  net/rfkill/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

I would suggest splitting this patch from the audit container ID
patchset and sending it to the netdev folks.  It really has nothing to
do with the audit container ID work, although I suspect I know why you
bumped into this spelling mistake ;)

> diff --git a/net/rfkill/core.c b/net/rfkill/core.c
> index 59d0eb9..e89a009 100644
> --- a/net/rfkill/core.c
> +++ b/net/rfkill/core.c
> @@ -494,7 +494,7 @@ void rfkill_remove_epo_lock(void)
>  /**
>   * rfkill_is_epo_lock_active - returns true EPO is active
>   *
> - * Returns 0 (false) if there is NOT an active EPO contidion,
> + * Returns 0 (false) if there is NOT an active EPO condition,
>   * and 1 (true) if there is an active EPO contition, which
>   * locks all radios in one of the BLOCKED states.
>   *
> --
> 1.8.3.1

-- 
paul moore
www.paul-moore.com
