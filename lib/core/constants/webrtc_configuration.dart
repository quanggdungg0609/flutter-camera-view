const Map<String, dynamic> iceServesConfig = {
  "iceServers": [
    {
      "urls": "stun:stun.l.google.com:19302",
    },
    {"urls": 'stun:stun.services.mozilla.com'},
  ],
};

const String sdpSemantics = 'unified-plan';

const Map<String, dynamic> config = {
  "mandatory": {},
  'optional': [
    {'DtlsSrtpKeyAgreement': true},
  ]
};

const Map<String, dynamic> offerSdpConstraints = {
  "mandatory": {
    "OfferToReceiveAudio": false,
    "OfferToReceiveVideo": true,
  },
  "optional": [],
};
