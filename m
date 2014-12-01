From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: kdbus: add code to gather metadata
Date: Mon, 1 Dec 2014 06:46:04 -0800
Message-ID: <CALCETrVcMxLZg1QLWYJEaCsUiDH6Uo7-EqEijHckbfJs_nQf4A@mail.gmail.com>
References: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org>
 <1416546149-24799-8-git-send-email-gregkh@linuxfoundation.org>
 <546F977B.7040500@amacapital.net> <547C723C.6020305@zonque.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <547C723C.6020305@zonque.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Mack <daniel@zonque.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Tom Gundersen <teg@jklm.no>, Jiri Kosina <jkosina@suse.cz>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, David Herrmann <dh.herrmann@gmail.com>, Djalal Harouni <tixxdz@opendz.org>
List-Id: linux-api@vger.kernel.org

On Mon, Dec 1, 2014 at 5:50 AM, Daniel Mack <daniel@zonque.org> wrote:
> Hi Andy,
>
> Sorry for the late response.
>
> On 11/21/2014 08:50 PM, Andy Lutomirski wrote:
>>> +static int kdbus_meta_append_cred(struct kdbus_meta *meta,
>>> +                              const struct kdbus_domain *domain)
>>> +{
>>> +    struct kdbus_creds creds = {
>>> +            .uid = from_kuid_munged(domain->user_namespace, current_uid()),
>>> +            .gid = from_kgid_munged(domain->user_namespace, current_gid()),
>>> +            .pid = task_pid_nr_ns(current, domain->pid_namespace),
>>> +            .tid = task_tgid_nr_ns(current, domain->pid_namespace),
>>
>> This is better than before -- at least it gets translation right part of
>> the way.  But it's still wrong if the receiver's namespace doesn't match
>> the domain.
>
> Alright. The code now translates the items into each receiver's
> namespaces individually, so we can also take possible chroot()
> environments into account to do path translations.

Thanks!

I suspect you'll get a lot of "(unreachable)/foo/bar".

>
>> Also, please move pid and tgid into their own item.  They suck for
>> reasons that have been beaten to death.  Let's make it possible to
>> deprecate them separately in the future.
>
> Ok, done now. As mentioned in the highpid thread, we can easily add
> another item once we have a better source of information.

I'll see if I can get highpid in soon enough that starttime can be
dropped entirely.  Once it shows up, there will be an API that can
probably never be removed that isn't namespaced correctly and can't be
checkpointed.

>
>>> +static int kdbus_meta_append_caps(struct kdbus_meta *meta)
>>> +{
>>> +    struct caps {
>>> +            u32 last_cap;
>>> +            struct {
>>> +                    u32 caps[_KERNEL_CAPABILITY_U32S];
>>> +            } set[4];
>>> +    } caps;
>>> +    unsigned int i;
>>> +    const struct cred *cred = current_cred();
>>> +
>>> +    caps.last_cap = CAP_LAST_CAP;
>>> +
>>> +    for (i = 0; i < _KERNEL_CAPABILITY_U32S; i++) {
>>> +            caps.set[0].caps[i] = cred->cap_inheritable.cap[i];
>>> +            caps.set[1].caps[i] = cred->cap_permitted.cap[i];
>>> +            caps.set[2].caps[i] = cred->cap_effective.cap[i];
>>> +            caps.set[3].caps[i] = cred->cap_bset.cap[i];
>>> +    }
>>
>> Please leave this in so that I can root every single kdbus-using system.
>>  It'll be lots of fun.
>>
>> Snark aside, the correct fix is IMO to delete this function entirely.
>> Even if you could find a way to implement it safely (which will be
>> distinctly nontrivial), it seems like a bad idea to begin with.
>
> Yes, we currently have no way of translating caps from one user
> namespace to another, which means we cannot allow such an item to cross
> user namespaces. We can add this functionality later once we have the
> neccessary APIs.

I still don't expect this metadata item to ever make sense to use.
The best argument I've heard is that it would enable CAP_SYS_BOOT to
ask systemd for a reboot.  I think this is bogus:

Realistically, this probably just means that users of /sbin/reboot
might continue to work as expected.  Except:

1. CAP_SYS_BOOT was never sufficient for /sbin/reboot to reboot
cleanly -- clean reboots historically went through /dev/initctl.

2. This only makes sense anyway if /sbin/reboot gets updated to speak
dbus.  So you have a new reboot binary that you want to work as long
as it ends up with CAP_SYS_BOOT.  But caps are so broken that this
won't work intelligently no matter what kdbus does.  A user can have
CAP_SYS_BOOT or not, but whether or not /sbin/reboot inherits that bit
is almost entirely a function of that user's euid and has very little
to do with whether that user has CAP_SYS_BOOT.  So you might as well
just check euid == 0 in the first place.

And setting fscap bits on /sbin/reboot so that a new reboot binary can
prove to systemd that it has CAP_SYS_BOOT makes no sense.  Either put
the policy in systemd in the first place, or make /sbin/reboot setuid
root.

And passing the permitted, inheritable, and bounding sets makes even
less sense.  Yes, you could pass the entirety of /proc/PID/stat and
/proc/PID/status, but that's silly, and passing caps around via kdbus
for diagnostics seems ridiculous.

If you put it in now, it's here to stay even if it proves to be a bad
idea, whereas if you don't put it in at first, you can always add it
if a good reason comes up.

>
>>> +#ifdef CONFIG_CGROUPS
>>> +static int kdbus_meta_append_cgroup(struct kdbus_meta *meta)
>>> +{
>>> +    char *buf, *path;
>>> +    int ret;
>>> +
>>> +    buf = (char *)__get_free_page(GFP_TEMPORARY | __GFP_ZERO);
>>> +    if (!buf)
>>> +            return -ENOMEM;
>>> +
>>> +    path = task_cgroup_path(current, buf, PAGE_SIZE);
>>
>> This may have strange interactions with cgroupns.  It's fixable, though,
>> but only once you implement translation at receive time, and I think
>> you'll have to do that to get any of this to work right.
>
> Yes, agreed. We'll add translation to this item once cgroup namespaces
> are in place. Until then, we'll expose the same information as other
> parts of the Linux API already do.

I don't expect this to become a problem.

>
>>> +#ifdef CONFIG_AUDITSYSCALL
>>> +static int kdbus_meta_append_audit(struct kdbus_meta *meta,
>>> +                               const struct kdbus_domain *domain)
>>> +{
>>> +    struct kdbus_audit audit;
>>> +
>>> +    audit.loginuid = from_kuid_munged(domain->user_namespace,
>>> +                                      audit_get_loginuid(current));
>>> +    audit.sessionid = audit_get_sessionid(current);
>>> +
>>> +    return kdbus_meta_append_data(meta, KDBUS_ITEM_AUDIT,
>>> +                                  &audit, sizeof(audit));
>>
>> So *that's* what audit means.  Please document this and consider
>> renaming it to something like AUDIT_LOGINUID_AND_SESSIONID.
>
> The documentation was indeed bogus and is fixed now, along with man
> other details. Thanks for spotting this!

:)


>
>>> +#ifdef CONFIG_SECURITY
>>> +static int kdbus_meta_append_seclabel(struct kdbus_meta *meta)
>>> +{
>>> +    u32 len, sid;
>>> +    char *label;
>>> +    int ret;
>>> +
>>> +    security_task_getsecid(current, &sid);
>>> +    ret = security_secid_to_secctx(sid, &label, &len);
>>> +    if (ret == -EOPNOTSUPP)
>>> +            return 0;
>>> +    if (ret < 0)
>>> +            return ret;
>>> +
>>> +    if (label && len > 0)
>>> +            ret = kdbus_meta_append_data(meta, KDBUS_ITEM_SECLABEL,
>>> +                                         label, len);
>>
>> This thing needs a clear, valid use case.  I think that the use case
>> should document how non-enforcing mode is supposed to work, too.
>
> kdbus just passes the seclabel along, if people want to use this for
> security checks, then they need to call into libselinux, and should do
> that by taking the enforcing mode into consideration. This is already
> done in a lot of software that way.
>
>> Also, there should be a justification for why the LSM hooks by
>> themselves aren't good enough to remove the need for this.
>
> SELinux and other MACs might want to do additional per-service security
> checks. For example, a service manager might want to check the security
> label of a service file against the security label of the client process
> using the SELinux database before allow access. For this, we need to be
> able to pass the client's security label race-free to libselinux so that
> it can make its decision.

Yeah, but what happens on systems that use a different LSM?  And isn't
the point of the new LSM kdbus hooks to do this automatically without
userspace's help?

Admittedly, I don't see much of a problem with this feature existing,
as long as the non-selinux people are okay with it.

>
> I've added the above to the documentation now.
>
>
>
> Thanks for your review again - much appreciated!

And thanks for addressing most of the issues.  The code is starting to
look much better to me.

--Andy
