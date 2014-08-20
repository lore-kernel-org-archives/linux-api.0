From: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3 0/6] namespaces: log namespaces per task
Date: Wed, 20 Aug 2014 12:25:11 -0400
Message-ID: <20140820162511.GS4462@madcap2.tricolour.ca>
References: <cover.1400271129.git.rgb@redhat.com>
	<1400593754.15733.4.camel@flatline.rdu.redhat.com>
	<20140520140146.GA8079@madcap2.tricolour.ca>
	<20140819164617.GE9003@madcap2.tricolour.ca>
	<8738crst5i.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <8738crst5i.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Steve Grubb <sgrubb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 14/08/19, Eric W. Biederman wrote:
> Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
> 
> > On 14/05/20, Richard Guy Briggs wrote:
> >> On 14/05/20, Eric Paris wrote:
> >> > On Tue, 2014-05-20 at 09:12 -0400, Richard Guy Briggs wrote:
> >> > > The purpose is to track namespaces in use by logged processes from the
> >> > > perspective of init_*_ns.
> >
> > (Including the Linux API list due to the additions to /proc/<pid>/ns/.
> > Please see http://www.kernelhub.org/?p=2&msg=477668 and in particular
> > http://www.kernelhub.org/?msg=477678&p=2 )
> 
> Sigh if you have to use something like this use the proc inode
> number.  It is the same thing.
> 
> I hate to claim it is unique absent of the proc superblock but it is and
> will be for the forseable future.  
> 
> It would be better to include the block device number that appears in
> proc of 3h of the primary mount of to qualify the number.  But it is not
> particularly important.  Coming up with an additional unique number that
> needs to be maintained seems stronlgy silly.

I am reading a contradiction here:
	https://www.redhat.com/archives/linux-audit/2013-March/msg00032.html

and this posting went completely ignored:
	https://www.redhat.com/archives/linux-audit/2014-January/msg00180.html

And then there was this patchset and thread where there was some good
discussion to clarify the use case:
	https://lkml.org/lkml/2014/4/22/662

Then V2:
	https://lkml.org/lkml/2014/5/9/637

Then V3 3 months ago:
	https://www.redhat.com/archives/linux-audit/2014-May/msg00071.html

I'm about to post another version of the patchset addressing Eric Paris'
concerns about record types, field naming...

> Eric
> 
> > <snip>
> >
> >> > > 5/6 provides an example of usage for audit_log_task_info() which is used by
> >> > > syscall audits, among others.  audit_log_task() and audit_common_recv_message()
> >> > > would be other potential use cases.
> >> > > 
> >> > > Proposed output format:
> >> > > This differs slightly from Aristeu's patch because of the label conflict with
> >> > > "pid=" due to including it in existing records rather than it being a seperate
> >> > > record.  The serial numbers are printed in hex.
> >> > > 	type=SYSCALL msg=audit(1399651071.433:72): arch=c000003e syscall=272 success=yes exit=0 a0=40000000 a1=ffffffffffffffff a2=0 a3=22 items=0 ppid=1 pid=483 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm="(t-daemon)" exe="/usr/lib/systemd/systemd" netns=97 utsns=2 ipcns=1 pidns=4 userns=3 mntns=5 subj=system_u:system_r:init_t:s0 key=(null)
> >> > 
> >> > I'm undecided if I'd rather see this as a separate NS_INFO record type.
> >> > It would mean we could filter them out of the logs...
> >> 
> >> I don't have a strong opinion either way.  Steve G.'s opinion would be
> >> helpful here.
> >
> > Breaking this out into a seperate record type would mean calling
> > audit_log_namespace_info() from the callers of audit_log_task_info()
> > (presently audit_log_link_denied(), ima_audit_measurement(),
> > audit_log_exit() ), but would make it easier to emit with other record
> > types.
> >
> >> > Do we print out lots of pidns=0 for tasks not in a newly created NS?  Do
> >> > we want to?
> >> 
> >> There is no "pidns=0", but I understand your point.  This would come
> >> back to Steve G.'s point about disappearing fields, and the value of
> >> having it as a seperate record that could be filtered.
> >> 
> >> > > 6/6 tracks the creation and deletion of of namespaces, listing the type of
> >> > > namespace instance, related namespace id if there is one and the newly minted
> >> > > serial number.
> >> > > 
> >> > > Proposed output format:
> >> > > 	type=NS_INIT msg=audit(1400217435.706:94): pid=524 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:mount_t:s0 type=20000 old_snum=0 snum=a1 res=1
> >> > 
> >> > I'd love to be able to grep for netns=20 and find both the NS_INIT and
> >> > the SYSCALL/NS_INFO records, instead of having them named different
> >> > things.  So basically I think you want to translate the type= into a
> >> > string for the old_X= and X=...
> >> 
> >> That actually makes a bit more sense, and we could do away with the
> >> "type=" field since the "Xns=" fields are self-describing.
> >
> > Steve, how do you feel about this since the NS_INIT/NS_DEL record type
> > would have changing fields amongst the 6 namespace types.  Only one of
> > the 6 would be present in each message.  I suppose we could have an
> > NS_INIT_XXX/NS_DEL_XXX for each namespace type.
> >
> >> - RGB
> >
> > - RGB
> >
> > --
> > Richard Guy Briggs <rbriggs-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
> > Remote, Ottawa, Canada
> > Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545

- RGB

--
Richard Guy Briggs <rbriggs-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
