From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: Re: [PATCH 03/98] drm.h: use __kernel_size_t instead of size_t
Date: Sun, 30 Aug 2015 13:42:30 +0300
Message-ID: <20150830104229.GW9187@lakka.kapsi.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
 <1433000370-19509-4-git-send-email-mikko.rapeli@iki.fi>
 <CACvgo50OLHbvk4scG+pSOW53gR8Ze=yrD4GvbmdE=YRgALjdow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CACvgo50OLHbvk4scG+pSOW53gR8Ze=yrD4GvbmdE=YRgALjdow-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Emil Velikov <emil.l.velikov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ML dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Jun 03, 2015 at 06:19:48PM +0100, Emil Velikov wrote:
> On 30 May 2015 at 16:37, Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org> wrote:
> > Fixes userspace compilation error:
> >
> > drm/drm.h:132:2: error: unknown type name =E2=80=98size_t=E2=80=99
> >
> > Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
> > ---
> >  include/uapi/drm/drm.h | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/include/uapi/drm/drm.h b/include/uapi/drm/drm.h
> > index ff6ef62..b197650 100644
> > --- a/include/uapi/drm/drm.h
> > +++ b/include/uapi/drm/drm.h
> > @@ -129,11 +129,11 @@ struct drm_version {
> >         int version_major;        /**< Major version */
> >         int version_minor;        /**< Minor version */
> >         int version_patchlevel;   /**< Patch level */
> > -       size_t name_len;          /**< Length of name buffer */
> > +       __kernel_size_t name_len;         /**< Length of name buffe=
r */
> >         char __user *name;        /**< Name of driver */
> > -       size_t date_len;          /**< Length of date buffer */
> > +       __kernel_size_t date_len;         /**< Length of date buffe=
r */
> >         char __user *date;        /**< User-space buffer to hold da=
te */
> > -       size_t desc_len;          /**< Length of desc buffer */
> > +       __kernel_size_t desc_len;         /**< Length of desc buffe=
r */
> >         char __user *desc;        /**< User-space buffer to hold de=
sc */
> >  };
> >
> > @@ -143,7 +143,7 @@ struct drm_version {
> >   * \sa drmGetBusid() and drmSetBusId().
> >   */
> >  struct drm_unique {
> > -       size_t unique_len;        /**< Length of unique */
> > +       __kernel_size_t unique_len;       /**< Length of unique */
> As the file is used by other platforms than Linux this change will
> break them. Can you add a typedef similar to how __u8 and friends are
> handled at the top of the file.

Yes, I added typedef size_t   __kernel_size_t; for other platforms.

-Mikko
