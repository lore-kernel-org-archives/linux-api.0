From: Lukasz Pawelczyk <l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2 0/7] Smack namespace
Date: Tue, 26 May 2015 18:27:35 +0200
Message-ID: <1432657655.1974.21.camel@samsung.com>
References: <1432209222-8479-1-git-send-email-l.pawelczyk@samsung.com>
	<1432557162-19123-1-git-send-email-l.pawelczyk@samsung.com>
	<556484BD.2060004@tycho.nsa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-reply-to: <556484BD.2060004-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
Cc: Lukasz Pawelczyk <havner-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jingoo Han <jg1.han-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Jeff Layton <jlayton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, John Johansen <john.johansen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Rafal Krypa <r.krypa-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy
List-Id: linux-api@vger.kernel.org

Hi,

Thanks for taking the interest and commenting on this.
Replies below.


On wto, 2015-05-26 at 10:35 -0400, Stephen Smalley wrote:
> On 05/25/2015 08:32 AM, Lukasz Pawelczyk wrote:
> > --- Design ideas ---
> > 
> > "Smack namespace" is rather "Smack labels namespace" as not the whole
> > MAC is namespaced, only the labels. There is a great analogy between
> > Smack labels namespace and the user namespace part that remaps UIDs.
> > 
> > The idea is to create a map of labels for a namespace so the namespace
> > is only allowed to use those labels. Smack rules are always the same
> > as in the init namespace (limited only by what labels are mapped) and
> > cannot be manipulated from the child namespace. The map is actually
> > only for labels' names. The underlying structures for labels remain
> > the same. The filesystem also stores the "unmapped" labels from the
> > init namespace.
> 
> How do you achieve that without introducing additional hooks or
> reworking the current hooks in the setxattr code path?  At present, the
> security module is allowed to rewrite getxattr requests on the
> security.* namespace but it isn't allowed to do that for setxattr, so if
> the process invokes setxattr with a mapped label, then it will be the
> mapped label that gets passed to the filesystem implementation, not the
> unmapped label.  The security module may internally store it in unmapped
> form and may even return that upon getxattr() calls, but if you then
> reboot the system and later fetch from the filesystem, it will get the
> mapped label value.

I call the inode operation by hand in the post_setxattr.

The label will effectively be set twice, which is not ideal, but there
is no other option right now without reworking the hooks as you said.

This shouldn't really be a problem because the Smack operations will not
use the filesystem label (even when it's set incorrectly for a moment)
but an already initialized smack_known structure for this inode that has
all the values filled in properly.

The only attack vector I can think of is hard rebooting the machine in a
way that mapped label is really saved in the filesystem before the
unmapped will have a chance. Should I be worried about that? This sounds
a little unreal.


@@ -1163,12 +1214,24 @@ static void smack_inode_post_setxattr(struct dentry *dentry, const char *name,
                skpp = &isp->smk_mmap;
 
        if (skpp) {
-               skp = smk_get_label(value, size, true);
+               skp = smk_get_label(value, size, true, ns);
 
                if (!IS_ERR(skp))
                        *skpp = skp;
                else
                        *skpp = &smack_known_invalid;
+
+               /*
+                * The label we get above might be a different than the one
+                * kernel has already set before calling this function.
+                * Be consistent and set the final value in the filesystem.
+                * The cases for this are errors and labels being used
+                * in a namespace where we want to store an unmapped
+                * value in the filesystem.
+                */
+               dentry->d_inode->i_op->setxattr(dentry, name,
+                                               (*skpp)->smk_known,
+                                               size, flags);
        }
 }
 


> 
> > --- Usage ---
> > 
> > Smack namespace is written using LSM hooks inside user namespace. That
> > means it's connected to it.
> > 
> > To create a new Smack namespace you need to unshare() user namespace
> > as usual. If that is all you do though, than there is no difference to
> > what is now. To activate the Smack namespace you need to fill the
> > labels' map. It is in a file /proc/$PID/smack_map.
> 
> This should be /proc/$PID/attr/label_map or similar, modeled after the
> existing /proc/$PID/attr/current and similar nodes.  Then it isn't
> module-specific and can be reused for other modules.

Sure. I had some thoughts about that, but couldn't really figure out
which option would be best. I'll change it as suggested.


> > Writing to the map file is not disabled after the first write as it is
> > in uid_map. For Smack we have no means to map ranges of labels, hence
> > it can really be advantageous to be able to expand the map later
> > on. But you can only add to the map. You cannot remove already mapped
> > labels. You cannot change the already existing mappings. Also mappings
> > has to be 1-1. All requests to create a map where either the unmapped
> > or the mapped label already exists in the map will be denied.
> 
> Isn't it a concern that I can then add additional labels to the mapping
> for which I am not authorized?  Or is this mitigated by the fact that I
> cannot alter the rules?  

You can't add mappings for which you are not authorized.
This is mitigated by both, by the fact that adding a mapping is a
privileged operation in the parent (only init for now) namespace and
that modifying the rules is a privileged operation allowed only in the
init namespace (as it is now).


> What about the situation for the predefined
> labels in Smack - are you assuming that they will always be mapped up
> front in the mapping file?

If somebody wants to have a full Smack aware container with full Smack
functionality that's what I'd expect, but it's not mandatory.



-- 
Lukasz Pawelczyk
Samsung R&D Institute Poland
Samsung Electronics
