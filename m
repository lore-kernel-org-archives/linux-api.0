From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH v2 0/7] Smack namespace
Date: Tue, 26 May 2015 12:34:16 -0400
Message-ID: <5564A088.4040507@tycho.nsa.gov>
References: <1432209222-8479-1-git-send-email-l.pawelczyk@samsung.com> <1432557162-19123-1-git-send-email-l.pawelczyk@samsung.com> <556484BD.2060004@tycho.nsa.gov> <1432657655.1974.21.camel@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1432657655.1974.21.camel@samsung.com>
Sender: linux-doc-owner@vger.kernel.org
To: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
Cc: "David S. Miller" <davem@davemloft.net>, "Eric W. Biederman" <ebiederm@xmission.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, "Serge E. Hallyn" <serge@hallyn.com>, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Casey Schaufler <casey@schaufler-ca.com>, David Howells <dhowells@redhat.com>, Fabian Frederick <fabf@skynet.be>, Greg KH <gregkh@linuxfoundation.org>, James Morris <james.l.morris@oracle.com>, Jeff Layton <jlayton@primarydata.com>, Jingoo Han <jg1.han@samsung.com>, Joe Perches <joe@perches.com>, John Johansen <john.johansen@canonical.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Miklos Szeredi <miklos@szeredi.hu>, Oleg Nesterov <oleg@redhat.com>, Paul Moore <paul@pa>
List-Id: linux-api@vger.kernel.org

On 05/26/2015 12:27 PM, Lukasz Pawelczyk wrote:
> Hi,
> 
> Thanks for taking the interest and commenting on this.
> Replies below.
> 
> 
> On wto, 2015-05-26 at 10:35 -0400, Stephen Smalley wrote:
>> On 05/25/2015 08:32 AM, Lukasz Pawelczyk wrote:
>>> --- Design ideas ---
>>>
>>> "Smack namespace" is rather "Smack labels namespace" as not the whole
>>> MAC is namespaced, only the labels. There is a great analogy between
>>> Smack labels namespace and the user namespace part that remaps UIDs.
>>>
>>> The idea is to create a map of labels for a namespace so the namespace
>>> is only allowed to use those labels. Smack rules are always the same
>>> as in the init namespace (limited only by what labels are mapped) and
>>> cannot be manipulated from the child namespace. The map is actually
>>> only for labels' names. The underlying structures for labels remain
>>> the same. The filesystem also stores the "unmapped" labels from the
>>> init namespace.
>>
>> How do you achieve that without introducing additional hooks or
>> reworking the current hooks in the setxattr code path?  At present, the
>> security module is allowed to rewrite getxattr requests on the
>> security.* namespace but it isn't allowed to do that for setxattr, so if
>> the process invokes setxattr with a mapped label, then it will be the
>> mapped label that gets passed to the filesystem implementation, not the
>> unmapped label.  The security module may internally store it in unmapped
>> form and may even return that upon getxattr() calls, but if you then
>> reboot the system and later fetch from the filesystem, it will get the
>> mapped label value.
> 
> I call the inode operation by hand in the post_setxattr.
> 
> The label will effectively be set twice, which is not ideal, but there
> is no other option right now without reworking the hooks as you said.
> 
> This shouldn't really be a problem because the Smack operations will not
> use the filesystem label (even when it's set incorrectly for a moment)
> but an already initialized smack_known structure for this inode that has
> all the values filled in properly.
> 
> The only attack vector I can think of is hard rebooting the machine in a
> way that mapped label is really saved in the filesystem before the
> unmapped will have a chance. Should I be worried about that? This sounds
> a little unreal.

If it were my security module, I would be worried about it.  Even aside
from maliciously induced failure, you are leaving yourself open to
inconsistencies arising upon crashes.  I would suggest modifying the
setxattr hook so that the security module can override the original
value/size pair with its own definition before it is passed to the inode
operation.  There is already precedent in that security modules are
allowed to override the value/size returned by getxattr for security.*,
so this just makes them fully parallel.

