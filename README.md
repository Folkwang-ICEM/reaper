# reaper

All decoder presets use the loudspeaker positions of the Neue Aula and ICEM's
studios. For software that can calculate angles for these from distances, see
ambi-speakers.lsp in the Lisp repository.

Note that as of 2.7.24 the channel order for Folkwang's *Beschallung* team is
essentially that which I proposed in order to be approximately Atmos-ready
(thanks Charles). The channels on the left, below, are the correct Dante
channels to route for the *Beschallung* team; those in parentheses on the right
are the SAD-P Dante input channels, for info only, i.e. not to be used by ICEM.

01: Vida Vorne L                (31)  
02: Vida Vorne R                (32)  
03: Center                      (33)  
04: Sub                         (34)   
05: Vida Hinten L               (35)  
06: Vida Hinten R               (36)  

07: Seite Links Vorn            (37)  
08: Seite Rechts Vorn           (38)  
09: Seite Links Hinten          (39)  
10: Seite Rechts Hinten         (40)  
11: Seite Links Mitte           (41)  
12: Seite Rechts Mitte          (42)  

13: Decke Links Vorn            (43)  
14: Decke Rechts Vorn           (44)  
15: Decke Links Hinten          (45)  
16: Decke Rechts Hinten         (46)  
17: Decke Links Mitte           (47)  
18: Decke Rechts Mitte          (48)  

19: not in use; was Hinten L    (49)  
20: not in use; was Hinten R    (50)  
21: Hinten Mitte                (51)  

22: Frontfill LL                (52)  
23: Frontfill L                 (53)  
24: Frontfill C                 (54)  
25: Frontfill R                 (55)  
26: Frontfill RR                (56)  
27: Empore LL                   (57)  
28: Empore L                    (58)  
29: Empore R                    (59)  
30: Empore RR                   (60)  

# atmos-like decoder presets

The Neue Aula Atmos-like presets (e.g. iem-decoder-neue-aula-7.4.json) are
offered merely for rendering a lower channel-count file from an Ambisonics
project so that, for example, you can play out of software such as QLab (which
is currently limited to 24 audio channels maximum). These decoders use the Neue
Aula loudspeaker positions so should not be used for an actual Atmos file
render, as Atmos uses different loudspeaker positions.

Note also two more things:

1) the channel numbers out of the Atmos-like decoders are simply consecutive,
i.e. they skip the LFE channel 4 so that you don't render unnecessary silent
channels. Take care of mapping to the actual speakers being used, e.g. with four
tops in e.g. 7.4, the middle top pair of the Neue Aula is not used; for the
sides in 7.4, the front side pair is not used; for the sides in 9.4, the middle
side pair is not used. All of this could be reconfigured of course, by making a
new decoder and deleting speakers from
e.g. iem-decoder-neue-aula-3-front-plus-rear-centre-no-fills.json.

2) as the LFE channel is skipped in the Atmos-like decoders, you'll need to use
e.g. SAD-P/Reaper/a mixing desk in order to make a send for the LFE on channel
4.

Michael Edwards, July 13th 2024

