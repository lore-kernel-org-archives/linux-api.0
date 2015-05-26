From: Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
Subject: Re: [PATCH v2 0/7] Smack namespace
Date: Tue, 26 May 2015 10:35:41 -0400
Message-ID: <556484BD.2060004__18764.2145007432$1432652027$gmane$org@tycho.nsa.gov>
References: <1432209222-8479-1-git-send-email-l.pawelczyk@samsung.com> <1432557162-19123-1-git-send-email-l.pawelczyk@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432557162-19123-1-git-send-email-l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lukasz Pawelczyk <l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jeff Layton <jlayton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Jingoo Han <jg1.han-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, John Johansen <john.johansen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, Oleg
Cc: Lukasz Pawelczyk <havner-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 05/25/2015 08:32 AM, Lukasz Pawelczyk wrote:
> --- Design ideas ---
> 
> "Smack namespace" is rather "Smack labels namespace" as not the whole
> MAC is namespaced, only the labels. There is a great analogy between
> Smack labels namespace and the user namespace part that remaps UIDs.
> 
> The idea is to create a map of labels for a namespace so the namespace
> is only allowed to use those labels. Smack rules are always the same
> as in the init namespace (limited only by what labels are mapped) and
> cannot be manipulated from the child namespace. The map is actually
> only for labels' names. The underlying structures for labels remain
> the same. The filesystem also stores the "unmapped" labels from the
> init namespace.

How do you achieve that without introducing additional hooks or
reworking the current hooks in the setxattr code path?  At present, the
security module is allowed to rewrite getxattr requests on the
security.* namespace but it isn't allowed to do that for setxattr, so if
the process invokes setxattr with a mapped label, then it will be the
mapped label that gets passed to the filesystem implementation, not the
unmapped label.  The security module may internally store it in unmapped
form and may even return that upon getxattr() calls, but if you then
reboot the system and later fetch from the filesystem, it will get the
mapped label value.

> --- Usage ---
> 
> Smack namespace is written using LSM hooks inside user namespace. That
> means it's connected to it.
> 
> To create a new Smack namespace you need to unshare() user namespace
> as usual. If that is all you do though, than there is no difference to
> what is now. To activate the Smack namespace you need to fill the
> labels' map. It is in a file /proc/$PID/smack_map.

This should be /proc/$PID/attr/label_map or similar, modeled after the
existing /proc/$PID/attr/current and similar nodes.  Then it isn't
module-specific and can be reused for other modules.

> Writing to the map file is not disabled after the first write as it is
> in uid_map. For Smack we have no means to map ranges of labels, hence
> it can really be advantageous to be able to expand the map later
> on. But you can only add to the map. You cannot remove already mapped
> labels. You cannot change the already existing mappings. Also mappings
> has to be 1-1. All requests to create a map where either the unmapped
> or the mapped label already exists in the map will be denied.

Isn't it a concern that I can then add additional labels to the mapping
for which I am not authorized?  Or is this mitigated by the fact that I
cannot alter the rules?  What about the situation for the predefined
labels in Smack - are you assuming that they will always be mapped up
front in the mapping file?
