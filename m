From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH 4/4] selftests: firmware: add empty string and async tests
Date: Wed, 9 Dec 2015 13:10:24 -0800
Message-ID: <CAGXu5j+wOx-NHo_hzBFUwAiUbBQT7J2axExNbb=ft87fAHG3hg@mail.gmail.com>
References: <1449628714-66641-1-git-send-email-computersforpeace@gmail.com>
	<1449628714-66641-4-git-send-email-computersforpeace@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449628714-66641-4-git-send-email-computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Brian Norris <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Dec 8, 2015 at 6:38 PM, Brian Norris
<computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Now that we've added a 'trigger_async_request' knob to test the
> request_firmware_nowait() API, let's use it. Also add tests for the
> empty ("") string, since there have been a couple errors in that
> handling already.
>
> Since we know have real wasy that the sysfs write might fail, let's add
> the appropriate check on the 'echo' lines too.
>
> Signed-off-by: Brian Norris <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Looks good!

Acked-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

-Kees

> ---
>  tools/testing/selftests/firmware/fw_filesystem.sh | 29 ++++++++++++++++++++++-
>  1 file changed, 28 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/firmware/fw_filesystem.sh b/tools/testing/selftests/firmware/fw_filesystem.sh
> index c4366dc74e01..e12210e1317c 100755
> --- a/tools/testing/selftests/firmware/fw_filesystem.sh
> +++ b/tools/testing/selftests/firmware/fw_filesystem.sh
> @@ -48,8 +48,21 @@ echo "ABCD0123" >"$FW"
>
>  NAME=$(basename "$FW")
>
> +if printf '\x00' >"$DIR"/trigger_request; then
> +       echo "$0: empty filename should not succeed" >&2
> +       exit 1
> +fi
> +
> +if printf '\x00' >"$DIR"/trigger_async_request; then
> +       echo "$0: empty filename should not succeed (async)" >&2
> +       exit 1
> +fi
> +
>  # Request a firmware that doesn't exist, it should fail.
> -echo -n "nope-$NAME" >"$DIR"/trigger_request
> +if echo -n "nope-$NAME" >"$DIR"/trigger_request; then
> +       echo "$0: firmware shouldn't have loaded" >&2
> +       exit 1
> +fi
>  if diff -q "$FW" /dev/test_firmware >/dev/null ; then
>         echo "$0: firmware was not expected to match" >&2
>         exit 1
> @@ -74,4 +87,18 @@ else
>         echo "$0: filesystem loading works"
>  fi
>
> +# Try the asynchronous version too
> +if ! echo -n "$NAME" >"$DIR"/trigger_async_request ; then
> +       echo "$0: could not trigger async request" >&2
> +       exit 1
> +fi
> +
> +# Verify the contents are what we expect.
> +if ! diff -q "$FW" /dev/test_firmware >/dev/null ; then
> +       echo "$0: firmware was not loaded (async)" >&2
> +       exit 1
> +else
> +       echo "$0: async filesystem loading works"
> +fi
> +
>  exit 0
> --
> 2.6.0.rc2.230.g3dd15c0
>



-- 
Kees Cook
Chrome OS & Brillo Security
