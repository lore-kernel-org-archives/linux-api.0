From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v5 2/3] Documentation/filesystems: Fixed typo
Date: Wed, 7 Sep 2016 16:22:42 -0700
Message-ID: <CAGXu5jL8w948TMyYPe-O0yoA9GjnWDpdAkFdD91YkechE4Fw-w@mail.gmail.com>
References: <1473106449-12847-1-git-send-email-robert.foss@collabora.com> <1473106449-12847-3-git-send-email-robert.foss@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1473106449-12847-3-git-send-email-robert.foss@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
To: robert.foss@collabora.com, Jonathan Corbet <corbet@lwn.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>, Konstantin Khlebnikov <koct9i@gmail.com>, n-horiguchi@ah.jp.nec.com, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, John Stultz <john.stultz@linaro.org>, Minchan Kim <minchan@kernel.org>, ross.zwisler@linux.intel.com, Jerome Marchand <jmarchan@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, mguzik@redhat.com, Janis Danisevskis <jdanis@google.com>, Calvin Owens <calvinowens@fb.com>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Sonny Rao <sonnyrao@chromium.org>, Seth Forshee <seth.forshee>
List-Id: linux-api@vger.kernel.org

On Mon, Sep 5, 2016 at 1:14 PM,  <robert.foss@collabora.com> wrote:
> From: Robert Foss <robert.foss@collabora.com>
>
> Fixed a -> an typo.
>
> Signed-off-by: Robert Foss <robert.foss@collabora.com>

Acked-by: Kees Cook <keescook@chromium.org>

This could be taken directly into the docs tree, I think -- no reason
to make it depend on the rest of the series.

-Kees

> ---
>  Documentation/filesystems/proc.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
> index 68080ad..fcc1ac0 100644
> --- a/Documentation/filesystems/proc.txt
> +++ b/Documentation/filesystems/proc.txt
> @@ -145,7 +145,7 @@ Table 1-1: Process specific entries in /proc
>                 symbol the task is blocked in - or "0" if not blocked.
>   pagemap       Page table
>   stack         Report full stack trace, enable via CONFIG_STACKTRACE
> - smaps         a extension based on maps, showing the memory consumption of
> + smaps         an extension based on maps, showing the memory consumption of
>                 each mapping and flags associated with it
>   numa_maps     an extension based on maps, showing the memory locality and
>                 binding policy as well as mem usage (in pages) of each mapping.
> --
> 2.7.4
>



-- 
Kees Cook
Nexus Security
