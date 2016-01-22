From: Mike Shal <marfey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4] fuse: Add support for passthrough
	read/write
Date: Fri, 22 Jan 2016 18:04:36 -0500
Message-ID: <CA+6x0LUrBHPf7YyNgwoY4c3fxACBpspycM45Tj=XWQ6oKsRK-g@mail.gmail.com>
References: <56A0235E.8090205@codeaurora.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6922473774444046465=="
Return-path: <fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <56A0235E.8090205-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/fuse-devel>,
	<mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=fuse-devel>
List-Post: <mailto:fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/fuse-devel>,
	<mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Nikhilesh Reddy <reddyn-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, fuse-devel <fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sven.utcke-Mmb7MZpHnFY@public.gmane.org, Nikolaus Rath <nikolaus-BTH8mxji4b0@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Jann Horn <jannhorn-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

--===============6922473774444046465==
Content-Type: multipart/alternative; boundary=001a113d616a3af2750529f43eed

--001a113d616a3af2750529f43eed
Content-Type: text/plain; charset=UTF-8

On Wed, Jan 20, 2016 at 7:16 PM, Nikhilesh Reddy <reddyn-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
wrote:

> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> @@ -569,6 +570,8 @@ ssize_t fuse_simple_request(struct fuse_conn *fc,
> struct fuse_args *args)
>         if (!ret && args->out.argvar) {
>                 BUG_ON(args->out.numargs != 1);
>                 ret = req->out.args[0].size;
> +               if (req->passthrough_filp != NULL)
> +                       args->out.passthrough_filp = req->passthrough_filp;
>         }
>         fuse_put_request(fc, req);
>
>
Is it correct to only set passthrough_filp when args->out.argvar is set
here? I tried to test your patch, but I'm still seeing read & write
requests to my FUSE filesystem after setting the passthrough bit. As far as
I can tell, args->out.argvar is only set in a few cases (like
fuse_follow_link()) but not where you're using it in fuse_create_open() or
fuse_send_open(). I changed the logic to this:

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 5cc5385..543c250 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -567,11 +567,14 @@ ssize_t fuse_simple_request(struct fuse_conn *fc,
struct fuse_args *args)
               args->out.numargs * sizeof(struct fuse_arg));
        fuse_request_send(fc, req);
        ret = req->out.h.error;
+       if (!ret) {
+               if (req->passthrough_filp != NULL) {
+                       args->out.passthrough_filp = req->passthrough_filp;
+               }
+       }
        if (!ret && args->out.argvar) {
                BUG_ON(args->out.numargs != 1);
                ret = req->out.args[0].size;
-               if (req->passthrough_filp != NULL)
-                       args->out.passthrough_filp = req->passthrough_filp;
        }
        fuse_put_request(fc, req);

And then it worked as expected. The only read() calls I see in my FUSE
filesystem after this change are from mmaped files, but it sounds like
you're already working on that. The performance is much improved for large
reads & writes, so thanks for working on this! I'm excited to see it
finished.

Note that I had to implement the libfuse side of things myself to test
this, so it's possible I'm doing something wrong there to trigger this
behavior. Maybe you could post your libfuse patches somewhere as well? Then
I can make sure I'm testing the same thing that you are.

Thanks,
-Mike

--001a113d616a3af2750529f43eed
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote">On W=
ed, Jan 20, 2016 at 7:16 PM, Nikhilesh Reddy <span dir=3D"ltr">&lt;<a href=
=3D"mailto:reddyn-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org" target=3D"_blank">reddyn-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org</=
a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0=
 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=3D""></s=
pan>diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c<br><div><div class=3D"h5">

@@ -569,6 +570,8 @@ ssize_t fuse_simple_request(struct fuse_conn *fc, struc=
t fuse_args *args)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!ret &amp;&amp; args-&gt;out.argvar) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 BUG_ON(args-&gt;out=
.numargs !=3D 1);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D req-&gt;out=
.args[0].size;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (req-&gt;passthr=
ough_filp !=3D NULL)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0args-&gt;out.passthrough_filp =3D req-&gt;passthrough_filp;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 fuse_put_request(fc, req);<br>
<br></div></div></blockquote><div><br></div><div>Is it correct to only set =
passthrough_filp when args-&gt;out.argvar is set here? I tried to test your=
 patch, but I&#39;m still seeing read &amp; write requests to my FUSE files=
ystem after setting the passthrough bit. As far as I can tell, args-&gt;out=
.argvar is only set in a few cases=20
(like fuse_follow_link()) but not where you&#39;re using it in=20
fuse_create_open() or fuse_send_open(). I changed the logic to this:<br><br=
>diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c<br>index 5cc5385..543c250 10064=
4<br>--- a/fs/fuse/dev.c<br>+++ b/fs/fuse/dev.c<br>@@ -567,11 +567,14 @@ ss=
ize_t fuse_simple_request(struct fuse_conn *fc, struct fuse_args *args)<br>=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 args-&gt;out.numargs * sizeof(struct fuse_arg));<br>=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fuse_request_send(fc, req);<br>=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D req-&gt;out.h.error;<br>+=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!ret) {<br>+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (req-&gt;passthro=
ugh_filp !=3D NULL) {<br>+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 args-&gt;out.passthrough_filp =3D req-&gt;passthrough_filp;<br>+=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 }<br>+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }<br>=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!ret &amp;&amp; args-&gt;out.argvar) {<br>=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 BUG_ON(args-&gt;out.numargs !=3D 1);<br>=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
t =3D req-&gt;out.args[0].size;<br>-=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (req-&gt;passthrough_filp =
!=3D NULL)<br>-=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ar=
gs-&gt;out.passthrough_filp =3D req-&gt;passthrough_filp;<br>=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 fuse_put_request(fc, req);<br><br></div><div>And then it worked as expe=
cted. The only read() calls I see in my FUSE filesystem after this change a=
re from mmaped files, but it sounds like you&#39;re already working on that=
. The performance is much improved for large reads &amp; writes, so thanks =
for working on this! I&#39;m excited to see it finished.<br><br></div><div>=
Note that I had to implement the libfuse side of things myself to test this=
, so it&#39;s possible I&#39;m doing something wrong there to trigger this =
behavior. Maybe you could post your libfuse patches somewhere as well? Then=
 I can make sure I&#39;m testing the same thing that you are.<br><br></div>=
<div>Thanks,<br></div><div>-Mike<br></div><div><br><br></div></div></div></=
div>

--001a113d616a3af2750529f43eed--


--===============6922473774444046465==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=267308311&iu=/4140
--===============6922473774444046465==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-- 
fuse-devel mailing list
To unsubscribe or subscribe, visit https://lists.sourceforge.net/lists/listinfo/fuse-devel

--===============6922473774444046465==--
